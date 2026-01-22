# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    name { Faker::Lorem.unique.word.capitalize }
    color { Faker::Color.hex_color }
    description { Faker::Lorem.sentence }

    trait :team_specific do
      association :team
    end
  end
end
