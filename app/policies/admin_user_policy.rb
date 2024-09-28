# app/policies/admin_user_policy.rb
class AdminUserPolicy < ActiveAdmin::BasePolicy
  def index?
    admin_user?
  end

  def show?
    admin_user?
  end

  def create?
    admin_user?
  end

  def update?
    admin_user?
  end

  def destroy?
    admin_user?
  end

  class Scope < Scope
    def resolve
      admin_user? ? scope.all : scope.none
    end
  end

  private

  def admin_user?
    user.is_a?(AdminUser) || user == :admin
  end
end