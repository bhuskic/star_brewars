require 'rails_helper'

RSpec.describe "Recipes API" do
  let! (:user) { create(:brewmaster, :user, :with_recipes) }
  let! (:recipe) { user.recipes.sample }

  context 'authorized' do
    let! (:auth_header) {  { 'Authorization' => "Token token=#{user.auth_token}" } }

    it 'should send a list of recipes' do
      all_recipes = Recipe.all

      get v1_recipes_path, {}, auth_header

      json = JSON.parse(response.body)

      expect(response).to be_success
      expect(json['recipes'].length).to eq(all_recipes.length)
    end

    it 'shows recipe' do
      get v1_recipe_path(recipe.id), {}, auth_header

      expect(response).to be_success
      expect(response.body).to eq(RecipeSerializer.new(recipe).to_json)
    end

    it 'creates new recipe' do
      new_recipe = FactoryGirl.attributes_for(:recipe)
      post v1_recipes_path, { 'recipe' => new_recipe.as_json }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(RecipeSerializer.new(Recipe.last).to_json)
    end

    it 'updates recipe' do
      put v1_recipe_path(recipe.id), { recipe: { name: 'Updated recipe name' } }, auth_header
      expect(response).to be_success
      expect(response.body).to eq(RecipeSerializer.new(Recipe.find(recipe.id)).to_json)
    end

    it 'deletes recipe' do
      delete v1_recipe_path(recipe.id), {}, auth_header
      expect(response).to be_success
      expect(response.body).to eq({ message: 'Recipe successfuly deleted.' }.to_json)
    end
  end

end
