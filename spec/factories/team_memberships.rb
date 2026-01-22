# frozen_string_literal: true

FactoryBot.define do
  factory :team_membership do
    user
    team
    role { "member" }

    trait :lead do
      role { "lead" }
    end
  end
end
