# frozen_string_literal: true

class WorkspaceChannel < ApplicationCable::Channel
  def subscribed
    workspace = Workspace.find(params[:workspace_id])

    # Verify user has access to this workspace
    membership = workspace.workspace_memberships.find_by(user: current_user)
    reject unless membership

    stream_for workspace
  end

  def unsubscribed
    stop_all_streams
  end

  # Broadcast helpers
  def self.broadcast_member_joined(workspace, member)
    broadcast_to(workspace, {
      type: "member.joined",
      member: member.as_json(only: %i[id name email avatar_url role]),
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_member_removed(workspace, member_id)
    broadcast_to(workspace, {
      type: "member.removed",
      member_id: member_id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_workspace_updated(workspace, changes)
    broadcast_to(workspace, {
      type: "workspace.updated",
      workspace_id: workspace.id,
      changes: changes,
      timestamp: Time.current.iso8601
    })
  end
end
