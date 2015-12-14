require 'rails_helper'

RSpec.describe IngredientPolicy do
  
  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:user) { create(:brewmaster, :user, :with_recipes) }
  let (:guest) { create(:brewmaster) }
  let (:ingredient) { Ingredient.new(name: 'test ingredient', type_name: 'test type', amount: '100 g') }

  subject { described_class }

  context 'admin role' do
    permissions :index?, :show?, :create?, :update?, :destroy? do
      it 'grants access' do
        expect(subject).to permit(admin, ingredient)
      end
    end
  end

  context 'other roles' do
    permissions :index?, :show? do
      it "grants access" do
        expect(subject).to permit(user, ingredient)
        expect(subject).to permit(guest, ingredient)
      end
    end

    permissions :create?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(user, ingredient)
        expect(subject).not_to permit(guest, ingredient)
      end
    end
  end
end
