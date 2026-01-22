# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    record.creator_id == user.id || admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
