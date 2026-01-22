# frozen_string_literal: true

class CommentSerializer < Blueprinter::Base
  identifier :id

  fields :body, :body_html, :edited_at, :created_at, :updated_at

  field :issue_id do |comment|
    comment.issue_id
  end

  field :user_id do |comment|
    comment.user_id
  end

  field :parent_id do |comment|
    comment.parent_id
  end

  field :edited do |comment|
    comment.edited?
  end

  view :with_user do
    association :user, blueprint: UserSerializer
  end

  view :with_replies do
    association :replies, blueprint: CommentSerializer, view: :with_user
  end

  view :detailed do
    include_view :with_user
    include_view :with_replies
  end
end
