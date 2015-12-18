require 'rails_helper'

RSpec.describe V1::GroceriesController, type: :controller do
  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:user) { create(:brewmaster, :user, :with_recipes) }
  let (:some_other_user) { create(:brewmaster) }
  let (:grocery) { create(:grocery) }

  describe 'GET index' do
    context 'authorized' do
      before(:example) {
        add_token(admin.auth_token)
      }

      it 'returns 200 status code' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'returns groceries' do
        get :index
        expect(response.body).to include('{"groceries":[{"id":')
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }

      it 'renders 403 status code' do
        get :index
        expect(response.body).to include('{"errors":["not authorized"]}')
        expect(response).to have_http_status(403)
      end
    end
  end

  describe '#GET show' do
    before(:example) {
      add_token(admin.auth_token)
    }

    context 'authorized' do
      it 'returns 200 status' do
        get :show, id: grocery.id
        expect(response).to have_http_status(200)
      end

      it 'returns role' do
        get :show, id: grocery.id
        expect(response.body).to eq(GrocerySerializer.new(grocery).to_json)
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns 403 status code' do
        get :show, id: grocery.id
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST create' do
    let (:new_grocery_params) {
      { grocery:
        { name: 'Pilsner malt',
          grocery_type: 'Malt',
          characteristics: 'Very pale malt'
        }
      }
    }
    before(:example) {
      add_token(admin.auth_token)
    }
    context 'authorized' do
      context 'success' do
        it 'returns 201 status' do
          post :create, new_grocery_params
          expect(response).to have_http_status(201)
        end

        it 'returns created role' do
          post :create, new_grocery_params
          expect(response.body).to eq(GrocerySerializer.new(Grocery.last).to_json)
        end
      end

      context 'failure' do
        it 'returns invalid resource code' do
          new_grocery_params[:grocery][:name] = ''
          post :create, new_grocery_params
          expect(response).to have_http_status(422)
        end

        it 'returns error message' do
          new_grocery_params[:grocery][:name] = ''
          post :create, new_grocery_params
          expect(response.body).to eq('{"name":["can\'t be blank"]}')
        end
      end
    end
    context "unauthorized" do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns 403 status code' do
        get :show, id: grocery.id
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PUT update' do
    before(:example) {
      add_token(admin.auth_token)
    }

    context 'authorized' do
      context "successful update" do
        it 'returns success status' do
          grocery.name = 'Come to the dark side of roles'
          put :update, id: grocery.id, grocery: grocery.as_json
          expect(response).to have_http_status(200)
        end

        it 'returns updated user' do
          grocery.name = "Melanoidin malt"
          put :update, id: grocery.id, grocery: grocery.as_json
          expect(response.body).to eq(GrocerySerializer.new(grocery).to_json)
        end
      end

      context 'failure' do
        it 'returns 500 status code' do
          grocery.name = ''
          put :update, id: grocery.id, grocery: grocery.as_json
          expect(response).to have_http_status(500)
        end

        it 'returns error message' do
          grocery.name = ''
          put :update, id: grocery.id, grocery: grocery.as_json
          expect(response.body).to include('{"name":["can\'t be blank"]}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns forbidden status' do
        put :update, id: grocery.id, role: grocery.as_json
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'authorized' do
      before(:example) {
        add_token(admin.auth_token)
      }
      context 'success' do
        it "returns success status" do
          delete :destroy, id: grocery.id
          expect(response).to have_http_status(200)
        end

        it 'returns success message' do
          delete :destroy, id: grocery.id
          expect(response.body).to include('{"message":"Grocery successfuly deleted."}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns forbidden status' do
        delete :destroy, id: grocery.id
        expect(response).to have_http_status(403)
      end
    end
  end
end
