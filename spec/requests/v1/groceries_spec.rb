require 'rails_helper'

RSpec.describe "Groceries API" do
  let! (:admin) { create(:brewmaster, :admin) }
  let! (:user) { create(:brewmaster, :user) }
  let! (:groceries) { create_list(:grocery, 5) }
  let! (:grocery) { groceries.sample }

  context 'authorized' do
    let! (:auth_header) {  { 'Authorization' => "Token token=#{admin.auth_token}" } }

    it 'should send a list of groceries' do
      all_groceries = Grocery.all

      get v1_groceries_path, {}, auth_header

      json = JSON.parse(response.body)

      expect(response).to be_success
      expect(json['groceries'].length).to eq(all_groceries.length)
    end

    it 'shows grocery' do
      get v1_grocery_path(grocery.id), {}, auth_header

      expect(response).to be_success
      expect(response.body).to eq(GrocerySerializer.new(grocery).to_json)
    end

    it 'creates new grocery' do
      new_grocery = FactoryGirl.attributes_for(:grocery)
      post v1_groceries_path, { 'grocery' => new_grocery.as_json }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(GrocerySerializer.new(Grocery.last).to_json)
    end

    it 'updates grocery' do
      put v1_grocery_path(grocery.id), { grocery: { name: 'Updated grocery name' } }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(GrocerySerializer.new(Grocery.find(grocery.id)).to_json)
    end

    it 'deletes grocery' do
      delete v1_grocery_path(grocery.id), {}, auth_header
      expect(response).to be_success
      expect(response.body).to eq({ message: 'Grocery successfuly deleted.' }.to_json)
    end
  end
  context "unauthorized" do
    let! (:auth_header) {  { 'Authorization' => "Token token=#{user.auth_token}" } }

    it "denies access" do
      get v1_grocery_path(grocery.id), {}, auth_header
      expect(response).to have_http_status(403)
      expect(response.body).to eq('{"errors":["not authorized"]}')
    end
  end

end
