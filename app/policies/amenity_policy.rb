class AmenityPolicy < ActiveAdmin::BasePolicy
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
    
      class Scope < Scope
        def resolve
          user.is_a?(AdminUser) ? scope.all : scope.none
        end
    end
end
