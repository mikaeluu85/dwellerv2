class Provider::MagicLinksPolicy < ApplicationPolicy
    def new?
      true
    end
  
    def create?
      true
    end
  
    def show?
      true
    end
  end