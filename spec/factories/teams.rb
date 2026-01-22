# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Company.buzzword.titleize }
    key { Faker::Alphanumeric.alpha(number: 3).upcase }
    description { Faker::Lorem.sentence }
    color { Faker::Color.hex_color }
  end
end
