# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    sequence(:slug) { |n| "#{Faker::Internet.slug}-#{n}" }
    description { Faker::Lorem.sentence }
    color { Faker::Color.hex_color }
    status { "in_progress" }
    privacy { "public" }

    trait :private do
      privacy { "private" }
    end

    trait :completed do
      status { "done" }
    end

    trait :backlog do
      status { "backlog" }
    end
  end
end
