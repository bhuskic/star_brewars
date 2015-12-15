class UserPolicy < ApplicationPolicy

  def owner?
    user == record
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
