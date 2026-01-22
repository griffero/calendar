# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    # Health check
    field :health, String, null: false, description: "Health check"

    def health
      "OK"
    end

    # Current user
    field :viewer, Types::UserType, null: true, description: "The currently authenticated user"

    def viewer
      context[:current_user]
    end
  end
end
