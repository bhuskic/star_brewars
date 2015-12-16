class UserPolicy < ApplicationPolicy
  def admin_user?
    user.roles.any? { |role| role.name == 'brewmaster_yoda' }
  end

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
