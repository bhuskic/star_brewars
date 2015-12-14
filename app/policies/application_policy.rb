class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'You must be logged in.' unless user
    @user = user
    @record = record
  end

  def index?
    admin_user?
  end

  def show?
    admin_user?
  end

  def create?
    admin_user?
  end

  def update?
    admin_user?
  end

  def destroy?
    admin_user?
  end

  def admin_user?
    user.roles.any? { |role| role.name == 'brewmaster_yoda' }
  end

  def user_user?
    user.roles.any? { |role| role.name == 'brewmaster_jedi' }
  end

  def guest_user?
    user.roles.any? { |role| role.name == 'brewmaster_padawan' }
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
