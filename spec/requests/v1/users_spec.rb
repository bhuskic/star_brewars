require 'rails_helper'

RSpec.describe "Users API" do
  context "user is authorized" do
    let! (:users) { create_list(:brewmaster, 6, :user) }
    let! (:admin) { create(:brewmaster, :admin) }
    let! (:auth_header) {  { 'Authorization' => "Token token=#{admin.auth_token}" } }

    it "sends a list of all users" do
      get v1_users_path, {}, auth_header
      json = JSON.parse(response.body)

      expect(response).to be_success
      expect(json['users'].length).to eq(users.length + 1)
    end

    it "shows users data" do
      user = users.sample
      get v1_user_path(user.id), {}, auth_header

      expect(response).to be_success
      expect(response.body).to eq(UserSerializer.new(user).to_json)
    end

    it "creates new user" do
      user = FactoryGirl.attributes_for(:brewmaster)
      post v1_users_path, { "user" => user.as_json }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(UserSerializer.new(User.last).to_json)
    end

    it "updates user" do
      user = users.sample
      put v1_user_path(user.id), { user: { name: "newusername" } }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(UserSerializer.new(User.find(user.id)).to_json)
    end

    it "destroys user" do
      user = users.sample
      delete v1_user_path(user.id), {}, auth_header
      expect(response).to be_success
      expect(response.body).to eq({ message: "User successfuly deleted." }.to_json)
    end
  end

  context "unauthenticated user" do
    it "sends 401" do
      get v1_users_path, {}
      expect(response).to have_http_status(401)
    end

    it "returns an error message" do
      get v1_users_path, {}
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end

  end

  context "unauthorized access" do
    let! (:user) { create(:brewmaster, :user) }
    let! (:auth_token) { { 'Authorization' => "Token token=#{user.auth_token}" } }
    it "sends 403" do
      get v1_users_path, {}, auth_token
      expect(response).to have_http_status(403)
    end

    it "returns an error message" do
      get v1_users_path, {}, auth_token
      expect(response.body).to eq({ errors: [ "not authorized" ] }.to_json)
    end

  end
end
