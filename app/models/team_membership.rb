# frozen_string_literal: true

class TeamMembership < ApplicationRecord
  ROLES = %w[lead member].freeze

  belongs_to :user
  belongs_to :team

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :team_id, message: "is already a member of this team" }

  scope :leads, -> { where(role: "lead") }
  scope :members, -> { where(role: "member") }

  def lead?
    role == "lead"
  end
end
