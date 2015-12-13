class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :type_name
      t.string :amount

      t.belongs_to :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
