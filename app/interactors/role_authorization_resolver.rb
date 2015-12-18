class RoleAuthorizationResolver
  attr_reader :role, :action, :policy

  def initialize(role:, action:, policy:)
    @role = role
    @action = action.to_s
    @policy = policy
  end

  def allowed_to?
    return false if role.nil? || action.empty?
    role_has_permission? && policy_scope_satisfied?
  end

  def role_has_permission?
    !permission_for_action.nil?
  end

  def policy_scope_satisfied?
    return true if permission_for_action.nil? ||
      permission_for_action.policy_scope.nil?
    policy.send(permission_for_action.policy_scope)
  rescue NoMethodError
    false
  end

  private

  def permission_for_action
    role.role_permissions.select { |rp|
      rp.policy_name == policy.class.name && rp.name == action
    }.first
  end

end
