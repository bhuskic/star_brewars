class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :name, :type_name, :amount

  has_one :recipe
end
