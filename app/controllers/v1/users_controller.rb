module V1
  class UsersController < ApplicationController
    before_action :authenticate, except: [:create]

    def index
      authorize current_user
      users = User.all
      render(json: ActiveModel::ArraySerializer.new(
        users,
        each_serializer: UserSerializer,
        root: 'users'), statuts: 200)
    end

    def show
      user = User.find(params[:id])
      authorize user
      render(json: user, status: 200)
    end

    def create
      skip_authorization
      user = User.create(user_params)
      if user && user.valid?
        status = 201
        json = UserSerializer.new(user)
      else
        status = 422
        json = user.errors
      end
      render  json: json , status: status
    end

    def update
      user = User.find(params[:id])
      authorize user
      if user.update_attributes(user_params)
        status = 200
        json = UserSerializer.new(user)
      else
        status = 500
        json = { error: 'There was an error while updating user.' }
      end
      render  json: json , status: status
    end

    def destroy
      user = User.find(params[:id])
      authorize user
      if user.destroy
        return render_response(200, { message: 'User successfuly deleted.'})
      else
        return render_response(500, { error: 'User couldnt be deleted' })
      end
    end

    def render_response(status, json)
      render json: json, status: status
    end

    private

    def user_params
      params.require(:user).
        permit(:name, :email, :password, :password_confirmation, :auth_token).
        delete_if { |k, v| v.nil? }
    end
  end
end
