# frozen_string_literal: true

class ProjectSerializer < Blueprinter::Base
  identifier :id

  fields :name, :slug, :description, :icon, :color, :privacy, :status,
         :start_date, :target_date, :created_at, :updated_at

  field :lead_id do |project|
    project.lead_id
  end

  view :minimal do
    # Only basic fields for lists
  end

  view :with_lead do
    association :lead, blueprint: UserSerializer
  end

  view :with_members do
    association :members, blueprint: UserSerializer
  end

  view :detailed do
    include_view :with_lead
    include_view :with_members
    field :settings
  end
end
