class RolePermission < ActiveRecord::Base
  validates_presence_of :name, :policy_name
  belongs_to :role

end
