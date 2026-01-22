# frozen_string_literal: true

class ProjectMembership < ApplicationRecord
  ROLES = %w[lead member].freeze

  belongs_to :user
  belongs_to :project

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :project_id, message: "is already a member of this project" }

  scope :leads, -> { where(role: "lead") }
  scope :members, -> { where(role: "member") }

  def lead?
    role == "lead"
  end
end
