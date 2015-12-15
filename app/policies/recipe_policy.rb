class RecipePolicy < ApplicationPolicy
  class Scope < Scope; end

  def index?
    admin_user? || user_user? || guest_user?
  end

  def show?
    admin_user? || user_user? || guest_user?
  end

  def create?
    admin_user? || user_user?
  end

  def update?
    admin_user? || (user_user? && user == record.user)
  end

  def destroy?
    admin_user? || (user_user? && user == record.user)
  end

  def owner?
    user == record.user
  end
end
