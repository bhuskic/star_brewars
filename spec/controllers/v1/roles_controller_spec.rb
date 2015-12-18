require 'rails_helper'

RSpec.describe V1::RolesController, type: :controller do
  let (:admin) { create(:brewmaster, :admin) }
  let (:user) { create(:brewmaster, :user) }
  let (:some_other_user) { create(:brewmaster) }
  let (:role) { user.roles.sample }

  describe 'GET index' do
    context 'authorized' do
      before(:example) {
        add_token(admin.auth_token)
      }

      it 'returns 200 status code' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'returns roles' do
        get :index
        expect(response.body).to include('{"roles":[{"id":')
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
        get :show, id: role.id
        expect(response).to have_http_status(200)
      end

      it 'returns role' do
        get :show, id: role.id
        expect(response.body).to eq(RoleSerializer.new(role).to_json)
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns 403 status code' do
        get :show, id: role.id
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST create' do
    let (:new_role_params) {
      { role:
        { name: 'brewmaster_doku',
          display_name: 'Dark side of roles'
        }
      }
    }
    before(:example) {
      add_token(admin.auth_token)
    }
    context 'authorized' do
      context 'success' do
        it 'returns 201 status' do
          post :create, new_role_params
          expect(response).to have_http_status(201)
        end

        it 'returns created role' do
          post :create, new_role_params
          expect(response.body).to eq(RoleSerializer.new(Role.last).to_json)
        end
      end

      context 'failure' do
        it 'returns invalid resource code' do
          new_role_params[:role][:name] = ''
          post :create, new_role_params
          expect(response).to have_http_status(422)
        end

        it 'returns error message' do
          new_role_params[:role][:name] = 'brewmaster_yoda'
          post :create, new_role_params
          expect(response.body).to eq('{"name":["has already been taken"]}')
        end
      end
    end
    context "unauthorized" do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns 403 status code' do
        get :show, id: role.id
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
          role.display_name = 'Come to the dark side of roles'
          put :update, id: role.id, role: role.as_json
          expect(response).to have_http_status(200)
        end

        it 'returns updated user' do
          role.name = "brewmaster_count_doku"
          put :update, id: role.id, role: role.as_json
          expect(response.body).to eq(RoleSerializer.new(role).to_json)
        end
      end

      context 'failure' do
        it 'returns 500 status code' do
          role.name = ''
          put :update, id: role.id, role: role.as_json
          expect(response).to have_http_status(500)
        end

        it 'returns error message' do
          role.display_name = ''
          put :update, id: role.id, role: role.as_json
          expect(response.body).to include('{"display_name":["can\'t be blank","is too short (minimum is 3 characters)","is invalid"]}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns forbidden status' do
        put :update, id: role.id, role: role.as_json
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
          delete :destroy, id: role.id
          expect(response).to have_http_status(200)
        end

        it 'returns success message' do
          delete :destroy, id: role.id
          expect(response.body).to include('{"message":"Role successfuly deleted."}')
        end
      end
    end

    context 'unauthorized' do
      before(:example) {
        add_token(user.auth_token)
      }
      it 'returns forbidden status' do
        delete :destroy, id: role.id
        expect(response).to have_http_status(403)
      end
    end
  end
end
