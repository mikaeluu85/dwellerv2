class PermutationPolicy < ActiveAdmin::BasePolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.is_a?(AdminUser)
  end

  def update?
    user.is_a?(AdminUser)
  end

  def destroy?
    user.is_a?(AdminUser)
  end
end