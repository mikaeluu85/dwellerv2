module ActiveAdmin
  class BasePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.is_a?(AdminUser)
          scope.all
        else
          scope.none
        end
      end
    end

    def index?
      user.is_a?(AdminUser)
    end

    def show?
      user.is_a?(AdminUser)
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
end