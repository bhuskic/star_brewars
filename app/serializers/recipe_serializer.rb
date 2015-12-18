class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :beer_type, :beer_style, :procedure_description, :ingredients

end
