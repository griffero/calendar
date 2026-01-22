# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :issue
    association :user
    body { Faker::Lorem.paragraph }

    trait :with_html do
      body_html { "<p>#{body}</p>" }
    end

    trait :edited do
      edited_at { 1.hour.ago }
    end

    trait :reply do
      association :parent, factory: :comment
    end
  end
end
