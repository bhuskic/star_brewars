module V1
  class RecipesController < ApplicationController
    def index
      authorize Recipe
      @recipes = Recipe.all
      render(json: ActiveModel::ArraySerializer.new(
        @recipes,
        each_serializer: RecipeSerializer,
        root: 'recipes'), statuts: 200)
    end
  end
end
