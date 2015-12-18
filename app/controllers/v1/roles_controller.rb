module V1
  class RolesController < ApplicationController
    def index
      authorize Role
      roles = Role.all
      render(json: ActiveModel::ArraySerializer.new(
        roles,
        each_serializer: RoleSerializer,
        root: 'roles'), statuts: 200)
    end

    def show
      role = Role.find(params[:id])
      authorize role
      render(json: role, status: 200)
    end

    def create
      role = Role.create(role_params)
      authorize role
      if role.valid?
        return render_response(201, RoleSerializer.new(role))
      else
        return render_response(422, role.errors)
      end
    end

    def update
      role = Role.find(params[:id])
      authorize role
      if role.update_attributes(role_params)
        return render_response(200, RoleSerializer.new(role))
      else
        return render_response(500, role.errors)
      end
    end

    def destroy
      role = Role.find(params[:id])
      authorize role
      if role.destroy
        return render_response(200, { message: 'Role successfuly deleted.'})
      else
        return render_response(500, role.errors)
      end
    end

    private

    def role_params
      params.require(:role).
        permit(:name, :display_name).
        delete_if { |k, v| v.nil? }
    end
  end
end
