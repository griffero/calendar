# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
  identifier :id

  fields :email, :name, :avatar_url, :timezone, :role, :created_at, :updated_at
end
