# frozen_string_literal: true

class IssueChannel < ApplicationCable::Channel
  def subscribed
    issue = Issue.find(params[:issue_id])

    # Verify user has access (through workspace membership)
    workspace_membership = issue.team.workspace.workspace_memberships.find_by(user: current_user)
    reject unless workspace_membership

    stream_for issue

    # Track presence
    add_presence(issue)
  end

  def unsubscribed
    remove_presence
    stop_all_streams
  end

  def typing_started
    issue = Issue.find(params[:issue_id])
    self.class.broadcast_to(issue, {
      type: "typing.started",
      user_id: current_user.id,
      user_name: current_user.name,
      timestamp: Time.current.iso8601
    })
  end

  def typing_stopped
    issue = Issue.find(params[:issue_id])
    self.class.broadcast_to(issue, {
      type: "typing.stopped",
      user_id: current_user.id,
      timestamp: Time.current.iso8601
    })
  end

  private

  def add_presence(issue)
    presence_key = "issue:#{issue.id}:presence"
    user_data = {
      id: current_user.id,
      name: current_user.name,
      avatar_url: current_user.avatar_url,
      joined_at: Time.current.iso8601
    }.to_json

    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")).tap do |redis|
      redis.hset(presence_key, current_user.id, user_data)
      redis.expire(presence_key, 1.hour.to_i)
    end

    broadcast_presence(issue)
  end

  def remove_presence
    return unless params[:issue_id]

    issue = Issue.find_by(id: params[:issue_id])
    return unless issue

    presence_key = "issue:#{issue.id}:presence"
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")).hdel(presence_key, current_user.id)
    broadcast_presence(issue)
  end

  def broadcast_presence(issue)
    presence_key = "issue:#{issue.id}:presence"
    redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
    users = redis.hgetall(presence_key).values.map { |v| JSON.parse(v) }

    self.class.broadcast_to(issue, {
      type: "presence.updated",
      users: users,
      timestamp: Time.current.iso8601
    })
  end

  # Broadcast helpers
  def self.broadcast_comment_created(issue, comment)
    broadcast_to(issue, {
      type: "comment.created",
      comment: comment_payload(comment),
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_comment_updated(issue, comment)
    broadcast_to(issue, {
      type: "comment.updated",
      comment: comment_payload(comment),
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_comment_deleted(issue, comment_id)
    broadcast_to(issue, {
      type: "comment.deleted",
      comment_id: comment_id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_reaction_added(issue, reaction)
    broadcast_to(issue, {
      type: "reaction.added",
      reaction: {
        id: reaction.id,
        comment_id: reaction.comment_id,
        user_id: reaction.user_id,
        emoji: reaction.emoji
      },
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_reaction_removed(issue, reaction_id, comment_id)
    broadcast_to(issue, {
      type: "reaction.removed",
      reaction_id: reaction_id,
      comment_id: comment_id,
      timestamp: Time.current.iso8601
    })
  end

  def self.comment_payload(comment)
    {
      id: comment.id,
      body: comment.body,
      user_id: comment.user_id,
      created_at: comment.created_at.iso8601,
      updated_at: comment.updated_at.iso8601
    }
  end
end
