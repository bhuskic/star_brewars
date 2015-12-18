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
        return render_response(201, UserSerializer.new(user))
      else
        return render_response(422, user.errors)
      end
    end

    def update
      user = User.find(params[:id])
      authorize user
      if user.update_attributes(user_params)
        return render_response(200, UserSerializer.new(user))
      else
        return render_response(500, user.errors)
      end
    end

    def destroy
      user = User.find(params[:id])
      authorize user
      if user.destroy
        return render_response(200, { message: 'User successfuly deleted.'})
      else
        return render_response(500, user.errors)
      end
    end

    private

    def user_params
      params.require(:user).
        permit(:name, :email, :password, :password_confirmation, :auth_token).
        delete_if { |k, v| v.nil? }
    end
  end
end
