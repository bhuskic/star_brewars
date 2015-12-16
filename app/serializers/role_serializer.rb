class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :role_permissions

end
