class UserPolicy < ApplicationPolicy
  def show?
    admin_user? || user == record
  end

  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      else
        scope.none
      end
    end
  end
end
