require 'rails_helper'

RSpec.describe Recipe do
  let (:recipe) { create(:recipe) }

  context "messages" do
    it { should respond_to :name }
    it { should respond_to :beer_type }
    it { should respond_to :beer_style }
    it { should respond_to :procedure_description}
    it { should respond_to :user}
    it { should respond_to :ingredients}
    it { should respond_to :grocery_ingredients}
  end

  context 'attribute validation' do
    describe '#name' do
      it 'is not valid without a name' do
        recipe.name = ''
        expect(recipe).not_to be_valid
      end

      it 'must be unique with case insensitivity' do
        dup = build(:recipe)
        dup.name = recipe.name.swapcase
        expect(dup).not_to be_valid
      end
    end

    describe '#beer_type' do
      it "is not valid without beer type" do
        recipe.beer_type = ''
        expect(recipe).not_to be_valid
      end
    end

    describe '#beer_style' do
      it "is not valid without beer style" do
        recipe.beer_style = ''
        expect(recipe).not_to be_valid
      end
    end
  end
end
