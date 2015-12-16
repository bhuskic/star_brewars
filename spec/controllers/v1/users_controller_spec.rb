require 'rails_helper'


RSpec.describe V1::UsersController, type: :controller do
  let (:admin) { create(:brewmaster, :admin) }
  let (:user) { create(:brewmaster, :user) }
  let (:some_other_user) { create(:brewmaster, :user) }

  def add_token token
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(
        "#{token}")
  end

  describe 'GET index' do
    context 'authorized' do
      before(:example) {
        add_token(admin.auth_token)
      }

      it 'returns 200 status code' do
        get :index
        expect(response).to have_http_status(200)
      end

      it "returns users" do
        get :index
        expect(response.body).to include('{"users":[{"id":')
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
      add_token(user.auth_token)
    }

    context 'authorized' do
      it 'returns 200 status' do
        get :show, id: user.id
        expect(response).to have_http_status(200)
      end

      it 'returns user' do
        get :show, id: user.id
        expect(response.body).to include('{"user":{"id":')
      end
    end

    context 'unauthorized' do
      it 'returns 403 status code' do
        get :show, id: some_other_user.id
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "POST create" do

  end

  describe 'PUT update' do
    before(:example) {
      add_token(admin.auth_token)
    }

    context 'authorized' do
      context "successful update" do
        it 'returns success status' do
          user.email = "new@email.com"
          put :update, id: user.id, user: user.as_json
          expect(response).to have_http_status(200)
        end

        it 'returns updated user' do
          user.name = "new_name"
          put :update, id: user.id, user: user.as_json
          expect(response.body).to include('"user":{"id"')
        end
      end

      context 'failure' do
        it 'returns 500 status code' do
          user.email = 'irregular_email.com'
          put :update, id: user.id, user: user.as_json
          expect(response).to have_http_status(500)
        end

        it 'returns error message' do
          user.email = 'irregular_email.com'
          put :update, id: user.id, user: user.as_json
          expect(response.body).to include('{"error":"There was an error while updating user."}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }

      it 'returns failure status' do
        put :update, id: some_other_user.id, user: some_other_user.as_json
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
          delete :destroy, id:user.id
          expect(response).to have_http_status(200)
        end

        it 'returns success message' do
          delete :destroy, id:user.id
          expect(response.body).to include('{"message":"User successfuly deleted."}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      context 'success' do
      end
    end
  end
end
