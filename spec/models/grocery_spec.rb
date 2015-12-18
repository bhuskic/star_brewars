require 'rails_helper'

RSpec.describe Grocery do
  let (:grocery) { create(:grocery) }

  context "messages" do
    it { should respond_to :name }
    it { should respond_to :grocery_type }
    it { should respond_to :characteristics }
    it { should respond_to :ingredients }
  end

  context 'attribute validations' do
    describe '#name' do
      it "is not valid without a name" do
        grocery.name = ""
        expect(grocery).not_to be_valid
      end
    end

    describe '#grocery_type' do
      it "is not valid without a grocery type" do
        grocery.grocery_type = nil
        expect(grocery).not_to be_valid
      end
    end
  end
end
