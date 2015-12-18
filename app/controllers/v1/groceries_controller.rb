module V1
  class GroceriesController < ApplicationController
    def index
      authorize Grocery
      groceries = Grocery.all
      render(json: ActiveModel::ArraySerializer.new(
        groceries,
        each_serializer: GrocerySerializer,
        root: 'groceries'), statuts: 200)
    end

    def show
      grocery = Grocery.find(params[:id])
      authorize grocery
      render(json: grocery, status: 200)
    end

    def create
      grocery = Grocery.create(grocery_params)
      authorize grocery
      if grocery.valid?
        return render_response(201, GrocerySerializer.new(grocery))
      else
        return render_response(422, grocery.errors)
      end
    end

    def update
      grocery = Grocery.find(params[:id])
      authorize grocery
      if grocery.update_attributes(grocery_params)
        return render_response(200, GrocerySerializer.new(grocery))
      else
        return render_response(500, grocery.errors)
      end
    end

    def destroy
      grocery = Grocery.find(params[:id])
      authorize grocery
      if grocery.destroy
        return render_response(200, { message: 'Grocery successfuly deleted.'})
      else
        return render_response(500, grocery.errors)
      end
    end

    private

    def grocery_params
      params.require(:grocery).
        permit(:name, :grocery_type, :characteristics).
        delete_if { |k, v| v.nil? }
    end
  end
end
