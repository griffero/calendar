# frozen_string_literal: true

FactoryBot.define do
  factory :issue_activity do
    association :issue
    association :user
    action { "updated" }

    trait :created do
      action { "created" }
    end

    trait :status_changed do
      action { "updated" }
      field { "status" }
      old_value { "todo" }
      new_value { "in_progress" }
    end

    trait :commented do
      action { "commented" }
    end

    trait :assigned do
      action { "assigned" }
      field { "assignee_id" }
    end
  end
end
