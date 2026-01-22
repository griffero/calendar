# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    association :team
    association :creator, factory: :user
    title { Faker::Lorem.sentence(word_count: 5) }
    description { Faker::Lorem.paragraph }
    status { "todo" }
    priority { 3 }

    trait :with_assignee do
      association :assignee, factory: :user
    end

    trait :with_project do
      association :project
    end

    trait :backlog do
      status { "backlog" }
    end

    trait :todo do
      status { "todo" }
    end

    trait :in_progress do
      status { "in_progress" }
      started_at { Time.current }
    end

    trait :done do
      status { "done" }
      completed_at { Time.current }
    end

    trait :canceled do
      status { "canceled" }
      canceled_at { Time.current }
    end

    trait :urgent do
      priority { 1 }
    end

    trait :high do
      priority { 2 }
    end

    trait :medium do
      priority { 3 }
    end

    trait :low do
      priority { 4 }
    end

    trait :no_priority do
      priority { 0 }
    end

    trait :with_due_date do
      due_date { Faker::Date.forward(days: 14) }
    end

    trait :overdue do
      due_date { Faker::Date.backward(days: 7) }
    end
  end
end
