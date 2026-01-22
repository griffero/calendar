# frozen_string_literal: true

class LinearCloneSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, _obj, _ctx)
    # TODO: Implement when needed for unions/interfaces
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Limit the complexity of queries
  max_complexity 200
  max_depth 15

  # Stop validating when there are too many errors
  validate_max_errors(100)

  # Relay-style connection limits
  default_max_page_size 50
end
