# frozen_string_literal: true

class Issue < ApplicationRecord
  include PgSearch::Model

  belongs_to :team
  belongs_to :creator, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :project, optional: true
  belongs_to :parent, class_name: "Issue", optional: true

  has_many :sub_issues, class_name: "Issue", foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
  has_many :issue_labels, dependent: :destroy
  has_many :labels, through: :issue_labels
  has_many :comments, dependent: :destroy
  has_many :activities, class_name: "IssueActivity", dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 500 }
  validates :identifier, presence: true, uniqueness: true
  validates :number, presence: true, uniqueness: { scope: :team_id }
  validates :status, presence: true, inclusion: { in: %w[backlog todo in_progress in_review done canceled] }
  validates :priority, presence: true, inclusion: { in: 0..4 }

  before_validation :set_identifier, on: :create
  after_create :record_created_activity
  after_update :record_update_activity

  enum :status, {
    backlog: "backlog",
    todo: "todo",
    in_progress: "in_progress",
    in_review: "in_review",
    done: "done",
    canceled: "canceled"
  }, prefix: true

  # Priority levels: 0=none, 1=urgent, 2=high, 3=medium, 4=low
  PRIORITY_LABELS = {
    0 => "No priority",
    1 => "Urgent",
    2 => "High",
    3 => "Medium",
    4 => "Low"
  }.freeze

  scope :open, -> { where.not(status: %w[done canceled]) }
  scope :closed, -> { where(status: %w[done canceled]) }
  scope :by_team, ->(team_id) { where(team_id: team_id) }
  scope :by_project, ->(project_id) { where(project_id: project_id) }
  scope :by_assignee, ->(user_id) { where(assignee_id: user_id) }
  scope :unassigned, -> { where(assignee_id: nil) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :overdue, -> { where("due_date < ?", Date.current).open }
  scope :due_soon, ->(days = 7) { where(due_date: Date.current..(Date.current + days.days)).open }
  scope :recent, -> { order(created_at: :desc) }

  pg_search_scope :search,
    against: { title: "A", description: "B", identifier: "A" },
    using: {
      tsearch: { prefix: true, dictionary: "english" },
      trigram: { threshold: 0.3 }
    }

  def priority_label
    PRIORITY_LABELS[priority]
  end

  def complete!
    update!(status: :done, completed_at: Time.current)
  end

  def cancel!
    update!(status: :canceled, canceled_at: Time.current)
  end

  def start!
    update!(status: :in_progress, started_at: Time.current)
  end

  def reopen!
    update!(status: :todo, completed_at: nil, canceled_at: nil)
  end

  private

  def set_identifier
    return if identifier.present?
    return unless team.present?

    next_number = team.next_issue_number!
    self.number = next_number
    self.identifier = "#{team.key}-#{next_number}"
  end

  def record_created_activity
    activities.create!(
      issue: self,
      user: creator,
      action: "created"
    )
  end

  def record_update_activity
    return unless saved_changes.any?

    significant_changes = saved_changes.except("updated_at", "search_vector")
    return if significant_changes.empty?

    significant_changes.each do |field, (old_value, new_value)|
      activities.create!(
        issue: self,
        user: Current.user || creator,
        action: "updated",
        field: field,
        old_value: old_value.to_s,
        new_value: new_value.to_s
      )
    end
  end
end
