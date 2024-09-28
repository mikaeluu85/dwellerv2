# app/policies/blog_post_policy.rb
class BlogPostPolicy < ActiveAdmin::BasePolicy
    def index?
        true  # Everyone can access the index, but we'll filter the results in the Scope
    end
    
    def show?
        record.visible? || user.is_a?(AdminUser)
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
            if user.is_a?(AdminUser)
                scope.all
            else
                scope.where(visible: true)
            end
        end
    end
end