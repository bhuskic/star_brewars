class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'You must be logged in.' unless user
    @user = user
    @record = record
  end

  [:index?, :show?, :create?, :update?, :destroy?].each do |method_name|
    define_method(method_name) do
      resolver.authorized?(method_name)
    end
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
