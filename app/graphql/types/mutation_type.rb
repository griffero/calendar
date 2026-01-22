# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description "The mutation root of this schema"

    # Placeholder mutation - will be replaced with real mutations
    field :test_mutation, String, null: false, description: "A test mutation"

    def test_mutation
      "Success"
    end
  end
end
