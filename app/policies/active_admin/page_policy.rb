module ActiveAdmin
    class PagePolicy < ApplicationPolicy
      # Allow access to the dashboard
      def show?
        admin_user?
      end

      # Allow access to the index action if `show?` is permitted
      def index?
        admin_user?
      end

      private

      def admin_user?
        user.is_a?(AdminUser)
      end
    end
end