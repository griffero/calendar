# frozen_string_literal: true

class TeamMembershipSerializer < Blueprinter::Base
  identifier :id

  fields :role, :created_at

  field :user_id do |membership|
    membership.user_id
  end

  field :team_id do |membership|
    membership.team_id
  end

  view :with_user do
    association :user, blueprint: UserSerializer
  end

  view :with_team do
    association :team, blueprint: TeamSerializer
  end
end
