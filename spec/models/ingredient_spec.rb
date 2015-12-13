require 'rails_helper'

RSpec.describe Ingredient do
  let (:ingredient) { create(:ingredient) }

  context "messages" do
    it { should respond_to :name }
    it { should respond_to :type_name }
    it { should respond_to :amount }
    it { should respond_to :recipe}
  end

  context 'attribute validations' do
    describe '#name' do
      it "is not valid without a name" do
        ingredient.name = ""
        expect(ingredient).not_to be_valid
      end
    end

    describe '#type_name' do
      it "is not valid without a ingredient type" do
        ingredient.type_name = nil
        expect(ingredient).not_to be_valid
      end
    end

    describe '#amount' do
      it "is not valid without amount" do
        ingredient.amount = ""
        expect(ingredient).not_to be_valid
      end
    end
  end
end
