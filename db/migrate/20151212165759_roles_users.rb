class RolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, id: false do |t|
      t.belongs_to :role, index: true, null: false
      t.belongs_to :user, index: true, null: false
    end
  end
end
