# frozen_string_literal: true

class IssueActivity < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :action, presence: true

  ACTIONS = %w[
    created
    updated
    commented
    assigned
    unassigned
    status_changed
    priority_changed
    label_added
    label_removed
    linked
    unlinked
    archived
    unarchived
  ].freeze

  validates :action, inclusion: { in: ACTIONS }

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(limit = 20) { ordered.limit(limit) }
end
