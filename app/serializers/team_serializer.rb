# frozen_string_literal: true

class TeamSerializer < Blueprinter::Base
  identifier :id

  fields :name, :key, :description, :icon, :color, :issue_counter, :created_at, :updated_at

  view :minimal do
    # Only basic fields for lists
  end

  view :with_members do
    association :members, blueprint: UserSerializer
  end

  view :detailed do
    include_view :with_members
    field :settings
  end
end
