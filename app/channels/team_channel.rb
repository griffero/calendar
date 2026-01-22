# frozen_string_literal: true

class TeamChannel < ApplicationCable::Channel
  def subscribed
    team = Team.find(params[:team_id])

    # Verify user has access (through workspace membership)
    workspace_membership = team.workspace.workspace_memberships.find_by(user: current_user)
    reject unless workspace_membership

    stream_for team
  end

  def unsubscribed
    stop_all_streams
  end

  # Broadcast helpers
  def self.broadcast_issue_created(team, issue, actor)
    broadcast_to(team, {
      type: "issue.created",
      issue: issue_payload(issue),
      actor_id: actor.id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_issue_updated(team, issue, changes, actor)
    broadcast_to(team, {
      type: "issue.updated",
      issue_id: issue.id,
      identifier: issue.identifier,
      changes: changes,
      actor_id: actor.id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_issue_deleted(team, issue_id, identifier, actor)
    broadcast_to(team, {
      type: "issue.deleted",
      issue_id: issue_id,
      identifier: identifier,
      actor_id: actor.id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_cycle_updated(team, cycle, changes)
    broadcast_to(team, {
      type: "cycle.updated",
      cycle_id: cycle.id,
      changes: changes,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_state_updated(team, state, changes)
    broadcast_to(team, {
      type: "state.updated",
      state_id: state.id,
      changes: changes,
      timestamp: Time.current.iso8601
    })
  end

  def self.issue_payload(issue)
    {
      id: issue.id,
      identifier: issue.identifier,
      title: issue.title,
      state_id: issue.state_id,
      priority: issue.priority,
      assignee_id: issue.assignee_id,
      project_id: issue.project_id,
      cycle_id: issue.cycle_id,
      position: issue.position,
      board_position: issue.board_position
    }
  end
end
