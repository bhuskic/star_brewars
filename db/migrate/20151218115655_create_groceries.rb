class CreateGroceries < ActiveRecord::Migration
  def change
    create_table :groceries do |t|
      t.string :name
      t.string :grocery_type
      t.text :characteristics

      t.timestamps null: false
    end
  end
end
