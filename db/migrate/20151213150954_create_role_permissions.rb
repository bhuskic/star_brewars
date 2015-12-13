class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.string :name
      t.string :policy_name
      t.string :policy_scope

      t.belongs_to :role, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
