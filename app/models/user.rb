# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # Direct associations (single-tenant)
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships
  has_many :led_projects, class_name: "Project", foreign_key: :lead_id, dependent: :nullify, inverse_of: :lead
  has_many :created_issues, class_name: "Issue", foreign_key: :creator_id, dependent: :nullify, inverse_of: :creator
  has_many :assigned_issues, class_name: "Issue", foreign_key: :assignee_id, dependent: :nullify, inverse_of: :assignee
  has_many :comments, dependent: :destroy
  has_many :issue_activities, dependent: :destroy

  # Roles: owner, admin, member
  enum :role, { member: "member", admin: "admin", owner: "owner" }, default: :member

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }
  validates :role, presence: true

  before_save :downcase_email

  scope :by_email, ->(email) { where("LOWER(email) = ?", email.downcase) }
  scope :admins, -> { where(role: %w[owner admin]) }
  scope :owners, -> { where(role: "owner") }

  def self.find_by_email(email)
    by_email(email).first
  end

  # Single-tenant role checks
  def owner?
    role == "owner"
  end

  def admin?
    role.in?(%w[owner admin])
  end

  def can_manage_users?
    admin?
  end

  def can_manage_teams?
    admin?
  end

  def can_manage_settings?
    admin?
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
