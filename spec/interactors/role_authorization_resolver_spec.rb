require 'rails_helper'

RSpec.describe RoleAuthorizationResolver do
  let (:user) { create(:brewmaster, :user) }
  let (:role) { instance_double(Role) }
  let (:policy) { double(RecipePolicy.new(user, object_double(Recipe)), owner: true)}
  let (:permissions_without_action) {
    [
      instance_double(RolePermission, name: 'show?', policy_name: 'RecipePolicy', policy_scope: nil),
      instance_double(RolePermission, name: 'index?', policy_name: 'RecipePolicy', policy_scope: nil)
    ]
  }
  let (:permissions_with_action) {
    [
        instance_double(RolePermission, name: 'show?', policy_name: 'RecipePolicy', policy_scope: nil),
        instance_double(RolePermission, name: 'create?', policy_name: 'RecipePolicy', policy_scope: "missing_method"),
        instance_double(RolePermission, name: 'update?', policy_name: 'RecipePolicy', policy_scope: "owner"),
        instance_double(RolePermission, name: 'index?', policy_name: 'RecipePolicy', policy_scope: nil)
    ]
  }

  subject (:resolver) { RoleAuthorizationResolver.new(role: role , action: 'update?', policy: policy) }

  before(:example) {
    allow(role).to receive(:role_permissions).and_return(permissions_with_action)
    allow(policy).to receive(:class).and_return(RecipePolicy)
  }

  describe '#initialize' do
    it 'should have role' do
      expect(resolver.role).not_to be_nil
    end

    it 'should have action' do
      expect(resolver.action).not_to be_nil
    end
  end

  describe '#allowed_to?' do
    context 'role or action is nil' do
      it 'should return false if role is nil' do
        resolver = RoleAuthorizationResolver.new(role: nil , action: 'create?', policy: policy)
        expect(resolver.allowed_to?).to be false
      end
      it 'should return false if action is empty' do
        resolver = RoleAuthorizationResolver.new(role: role , action: nil, policy: policy)
        expect(resolver.allowed_to?).to be false
      end
    end
  end

  describe '#role_has_permission?' do

    it 'should return false if role doesnt have permission' do
      allow(role).to receive(:role_permissions).and_return(permissions_without_action)
      expect(resolver.role_has_permission?).to be false
    end

    it 'should return true if role contains permission of interest' do
      expect(resolver.role_has_permission?).to be true
    end
  end

  describe '#policy_scopes_satisfied?' do
    it "should send message to policy" do
      allow(role).to receive(:role_permissions).and_return(permissions_with_action)
      expect(resolver.policy_scope_satisfied?).to be true
    end

    context "no permission for action" do
      it "should return true" do
        allow(role).to receive(:role_permissions).and_return(permissions_without_action)
        expect(resolver.policy_scope_satisfied?).to be true
      end
    end

    context "there is no policy_scope assigned" do
      it 'should return true' do
        resolver = RoleAuthorizationResolver.new(role: role , action: 'show?', policy: policy)
        allow(role).to receive(:role_permissions).and_return(permissions_with_action)
        expect(resolver.policy_scope_satisfied?).to be true
      end
    end

    context 'missing resource scope method' do
      it 'returns false if no existing method for defined resource scope' do
        resolver = RoleAuthorizationResolver.new(role: role , action: 'create?', policy: policy)
        allow(policy).to receive(:missing_method).and_raise(NoMethodError)
        expect(resolver.policy_scope_satisfied?).to be false
      end
    end
  end
end
