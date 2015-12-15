class RecipePolicy < ApplicationPolicy
  class Scope < Scope; end

  def owner?
    user == record.user
  end
end
