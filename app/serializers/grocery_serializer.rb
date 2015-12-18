class GrocerySerializer < ActiveModel::Serializer
  attributes :id, :name, :grocery_type, :characteristics

end
