# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    timezone { "UTC" }
    role { "member" }

    trait :with_avatar do
      avatar_url { Faker::Avatar.image }
    end

    trait :admin do
      role { "admin" }
    end

    trait :owner do
      role { "owner" }
    end
  end
end
