require 'rails_helper'

RSpec.describe Ingredient do
  let (:ingredient) { create(:ingredient) }

  context "messages" do
    it { should respond_to :amount }
    it { should respond_to :recipe }
    it { should respond_to :grocery }
  end

  context 'attribute validations' do
    describe '#amount' do
      it "is not valid without amount" do
        ingredient.amount = ""
        expect(ingredient).not_to be_valid
      end
    end
  end

end

