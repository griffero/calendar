# frozen_string_literal: true

class Project < ApplicationRecord
  STATUSES = %w[active paused completed canceled].freeze
  PRIVACIES = %w[public private].freeze

  belongs_to :lead, class_name: "User", optional: true
  has_many :project_memberships, dependent: :destroy
  has_many :members, through: :project_memberships, source: :user
  has_many :issues, dependent: :nullify

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :slug, presence: true,
                   length: { minimum: 2, maximum: 50 },
                   format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "must be lowercase with hyphens only" },
                   uniqueness: { message: "is already taken" }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :privacy, presence: true, inclusion: { in: PRIVACIES }

  before_validation :generate_slug, on: :create

  scope :active, -> { where(status: "active") }
  scope :public_projects, -> { where(privacy: "public") }
  scope :ordered, -> { order(:name) }

  def active?
    status == "active"
  end

  def public?
    privacy == "public"
  end

  def private?
    privacy == "private"
  end

  private

  def generate_slug
    return if slug.present?

    base_slug = name.to_s.parameterize
    self.slug = base_slug

    counter = 1
    while Project.where(slug: slug).exists?
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end
