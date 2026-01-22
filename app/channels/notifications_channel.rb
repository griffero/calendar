# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    stop_all_streams
  end

  # Broadcast helpers
  def self.broadcast_notification(user, notification)
    broadcast_to(user, {
      type: "notification.created",
      notification: notification_payload(notification),
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_notification_read(user, notification_id)
    broadcast_to(user, {
      type: "notification.read",
      notification_id: notification_id,
      timestamp: Time.current.iso8601
    })
  end

  def self.broadcast_inbox_updated(user, unread_count)
    broadcast_to(user, {
      type: "inbox.updated",
      unread_count: unread_count,
      timestamp: Time.current.iso8601
    })
  end

  def self.notification_payload(notification)
    {
      id: notification.id,
      type: notification.type,
      data: notification.data,
      issue_id: notification.issue_id,
      actor_id: notification.actor_id,
      read_at: notification.read_at&.iso8601,
      created_at: notification.created_at.iso8601
    }
  end
end
