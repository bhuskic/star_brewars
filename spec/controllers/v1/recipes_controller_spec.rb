require 'rails_helper'

RSpec.describe V1::RecipesController do
  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:users) { create_list(:brewmaster, 5, :user, :with_recipes) }
  let (:guest) { create(:brewmaster) }
  let (:recipe) { users.sample.recipes.sample }

  describe 'GET #index' do
    before(:example) {
      add_token(admin.auth_token)
    }

    it 'returns 200 status code' do
      get :index
      expect(response).to have_http_status(200)
    end

    it "returns all recipes" do
      get :index
      expect(response.body).to include('{"recipes":[{"id":')
    end
  end

  describe 'GET #show' do
    before(:example) {
      add_token(guest.auth_token)
    }

    it 'returns 200 status' do
      get :show, id: recipe.id
      expect(response).to have_http_status(200)
    end

    it 'returns recipe' do
      get :show, id: recipe.id
      expect(response.body).to eq(RecipeSerializer.new(recipe).to_json)
    end
  end

  describe '#create' do
    let (:new_recipe_params) {
      { recipe:
        { name: 'Pale ale',
          beer_style: 'English pale ale',
          beer_type: 'ale',
          procedure_description: 'Single mash infusion at 63 degrees Celsius....'
        }
      }
    }
    context 'authorized' do
      before(:example) {
        add_token(users.sample.auth_token)
      }
      context "success" do
        it "returns 201 status" do
          post :create, new_recipe_params
          expect(response).to have_http_status(201)
        end

        it "returns created user" do
          post :create, new_recipe_params
          expect(response.body).to eq(RecipeSerializer.new(Recipe.last).to_json)
        end
      end

      context "failure" do
        it "returns invalid resource code" do
          new_recipe_params[:recipe][:name] = ""
          post :create, new_recipe_params
          expect(response).to have_http_status(422)
        end

        it "returns error message" do
          new_recipe_params[:recipe][:name] = users.sample.recipes.sample.name
          post :create, new_recipe_params
          expect(response.body).to eq('{"name":["has already been taken"]}')
        end
      end
    end
    context "unauthorized" do
      before(:example) {
        add_token(guest.auth_token)
      }
      it "returns 403" do
        post :create, new_recipe_params
        expect(response).to have_http_status(403)
      end

      it "returns not authorized message" do
        post :create, new_recipe_params
        expect(response.body).to include('{"errors":["not authorized"]}')
      end
    end
  end

  describe 'POST #update' do
    before(:example) {
      add_token(admin.auth_token)
    }

    context 'authorized' do
      context "successful update" do
        it 'returns success status' do
          recipe.name = "New recipe name"
          put :update, id: recipe.id, recipe: recipe.as_json
          expect(response).to have_http_status(200)
        end

        it 'returns updated user' do
          recipe.procedure_description = "New procedure description"
          put :update, id: recipe.id, recipe: recipe.as_json
          expect(response.body).to eq(RecipeSerializer.new(recipe).to_json)
        end
      end

      context 'failure' do
        it 'returns 500 status code' do
          recipe.beer_type = ""
          put :update, id: recipe.id, recipe: recipe.as_json
          expect(response).to have_http_status(500)
        end

        it 'returns error message' do
          recipe.beer_style = ""
          put :update, id: recipe.id, recipe: recipe.as_json
          expect(response.body).to include('{"beer_style":["can\'t be blank"]}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(guest.auth_token)
      }

      it 'returns failure status' do
        put :update, id: recipe.id, recipe: recipe.as_json
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized' do
      before(:example) {
        add_token(admin.auth_token)
      }

      context 'success' do
        it "returns success status" do
          delete :destroy, id:recipe.id
          expect(response).to have_http_status(200)
        end

        it 'returns success message' do
          delete :destroy, id:recipe.id
          expect(response.body).to include('{"message":"Recipe successfuly deleted."}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(guest.auth_token)
      }
      it 'returns forbidden status' do
        delete :destroy, id: recipe.id
        expect(response).to have_http_status(403)
      end
    end
  end
end
