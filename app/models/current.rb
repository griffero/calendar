# frozen_string_literal: true

# Thread-safe storage for current request context
# Used to access current user in model callbacks
class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :workspace
end
