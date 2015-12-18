require 'rails_helper'

RSpec.describe "Roles API" do
  let!(:admin) { create(:brewmaster, :admin) }
  let!(:user) { create(:brewmaster, :user) }
  let!(:role) { user.roles.sample }

  context 'authorized' do
    let! (:auth_header) {  { 'Authorization' => "Token token=#{admin.auth_token}" } }

    it 'should send a list of roles' do
      all_roles = Role.all

      get v1_roles_path, {}, auth_header

      json = JSON.parse(response.body)

      expect(response).to be_success
      expect(json['roles'].length).to eq(all_roles.length)
    end

    it 'shows role' do
      get v1_role_path(role.id), {}, auth_header

      expect(response).to be_success
      expect(response.body).to eq(RoleSerializer.new(role).to_json)
    end

    it 'creates new role' do
      new_role = FactoryGirl.attributes_for(:role)
      post v1_roles_path, { 'role' => new_role.as_json }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(RoleSerializer.new(Role.last).to_json)
    end

    it 'updates role' do
      put v1_role_path(role.id), { role: { name: 'new_updated_name' } }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(RoleSerializer.new(Role.find(role.id)).to_json)
    end

    it 'deletes role' do
      delete v1_role_path(role.id), {}, auth_header
      expect(response).to be_success
      expect(response.body).to eq({ message: 'Role successfuly deleted.' }.to_json)
    end
  end
  context "unauthorized" do
    let! (:auth_header) {  { 'Authorization' => "Token token=#{user.auth_token}" } }

    it "denies access" do
      get v1_role_path(role.id), {}, auth_header
      expect(response).to have_http_status(403)
      expect(response.body).to eq('{"errors":["not authorized"]}')
    end
  end
end
