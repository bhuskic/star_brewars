class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'You must be logged in.' unless user
    @user = user
    @record = record
  end

  def index?
    resolver.authorized?(__method__)
  end

  def show?
    resolver.authorized?(__method__)
  end

  def create?
    resolver.authorized?(__method__)
  end

  def update?
    resolver.authorized?(__method__)
  end

  def destroy?
    resolver.authorized?(__method__)
  end

  def admin_user?
    user.roles.any? { |role| role.name == 'brewmaster_yoda' }
  end

  def resolver
    resolver ||= UserAuthorizationResolver.new(user: user, context: self)
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
