require 'rails_helper'

RSpec.describe "Recipes API" do
  let! (:user) { create(:brewmaster, :user, :with_recipes) }

  it "should send a list of recipes" do
    all_recipes = Recipe.all

    get v1_recipes_path, {}, { 'Authorization' => "Token token=#{user.auth_token}" }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json['recipes'].length).to eq(all_recipes.length)
  end
end
