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

    def show
      recipe = Recipe.find(params[:id])
      authorize recipe
      render(json: recipe, status: 200)
    end

    def create
      authorize Recipe
      recipe = Recipe.create(recipe_params)
      if recipe.valid?
        return render_response(201, RecipeSerializer.new(recipe))
      else
        return render_response(422, recipe.errors)
      end
    end

    def update
      recipe = Recipe.find(params[:id])
      authorize recipe
      if recipe.update_attributes(recipe_params)
        return render_response(200, RecipeSerializer.new(recipe))
      else
        return render_response(500, recipe.errors)
      end
    end

    def destroy
      recipe = Recipe.find(params[:id])
      authorize recipe
      if recipe.destroy
        return render_response(200, { message: 'Recipe successfuly deleted.'})
      else
        return render_response(500, recipe.errors)
      end
    end

    private

    def recipe_params
      params.require(:recipe).
        permit(:name, :beer_style, :beer_type, :procedure_description).
        delete_if { |k, v| v.nil? }
    end
  end
end
