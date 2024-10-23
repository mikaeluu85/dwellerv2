# app/policies/blog_post_policy.rb
class BlogPostPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if user.is_a?(AdminUser)
                scope.all
            else
                scope.where(visible: true)
            end
        end
    end

    def index?
        true # Allow anyone to view the index
    end

    def show?
        return true if user.is_a?(AdminUser)
        record.visible?
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

    private

    def admin_user?
        user.is_a?(AdminUser)
    end
end
