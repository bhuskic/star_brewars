class UserAuthorizationResolver
  attr_reader :user, :context, :roles

  def initialize(user:, context:)
    @user = user
    @context = context
    @roles = user.roles || []
  end

  def authorized?(action=nil)
    return false if action.nil?
    roles.any? { |role|
      role_authorized?(role, action)
    }
  end

  private

  def role_authorized?(role, action)
    RoleAuthorizationResolver.new(role: role, action: action, policy: context).allowed_to?
  end

end
