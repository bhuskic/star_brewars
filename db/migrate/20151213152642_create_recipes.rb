class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string      :name
      t.string      :beer_style
      t.string      :beer_type
      t.text        :procedure_description
      t.belongs_to  :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
