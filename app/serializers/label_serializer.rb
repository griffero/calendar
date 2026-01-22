# frozen_string_literal: true

class LabelSerializer < Blueprinter::Base
  identifier :id

  fields :name, :color, :description, :created_at, :updated_at

  field :workspace_id do |label|
    label.workspace_id
  end

  field :team_id do |label|
    label.team_id
  end
end
