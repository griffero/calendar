# frozen_string_literal: true

class IssueActivitySerializer < Blueprinter::Base
  identifier :id

  fields :action, :field, :old_value, :new_value, :created_at

  field :issue_id do |activity|
    activity.issue_id
  end

  field :user_id do |activity|
    activity.user_id
  end

  view :with_user do
    association :user, blueprint: UserSerializer
  end
end
