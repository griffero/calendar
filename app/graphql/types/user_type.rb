# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description "A user in the system"

    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: false
    field :avatar_url, String, null: true
    field :timezone, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
