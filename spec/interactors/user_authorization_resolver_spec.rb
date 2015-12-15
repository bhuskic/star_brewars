require 'rails_helper'
require_relative '../../app/interactors/role_authorization_resolver'

RSpec.describe UserAuthorizationResolver do
  let (:user) { create(:brewmaster, :user) }
  let (:policy) { object_double(RecipePolicy.new(user, object_double(Recipe)))}
  subject (:resolver) { UserAuthorizationResolver.new(user: user, context: policy) }

  describe '#initialize' do
    it 'should have user' do
      expect(resolver.user).not_to be_nil
    end

    it 'should have policy object' do
      expect(resolver.context).not_to be_nil
    end
  end

  describe '#authorized?' do
    context 'action is nil' do
      it "should return false" do
        expect(resolver.authorized?).to be false
      end
    end

    context 'user roles' do
      it 'should send allowed_to? to RoleAuthorizationResolver for each' do
        action = "index?"
        role_authorizer = double("RoleAuthorizationResolver")
        user.roles.each do |role|
          allow(RoleAuthorizationResolver).to receive(:new).with(role: role, action: action, policy: policy).and_return(role_authorizer)
          expect(role_authorizer).to receive(:allowed_to?)
        end
        resolver.authorized?("index?")
      end
    end
  end

end
