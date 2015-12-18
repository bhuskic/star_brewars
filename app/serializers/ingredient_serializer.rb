class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :amount, :name, :grocery_type

  has_one :recipe
  has_one :grocery
end
