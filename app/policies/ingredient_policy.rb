class IngredientPolicy < ApplicationPolicy
  class Scope < Scope; end

  def index?
    admin_user? || user_user? || guest_user?
  end

  def show?
    admin_user? || user_user? || guest_user?
  end

end
