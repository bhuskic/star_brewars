require 'rails_helper'

RSpec.describe RecipePolicy do

  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:user) { create(:brewmaster, :user, :with_recipes) }
  let (:guest) { create(:brewmaster) }

  subject { described_class }

  context 'admin role' do
    permissions :index?, :show?, :create?, :update?, :destroy? do
      it 'should have access to all recipe actions' do
        expect(subject).to permit(admin, user.recipes.sample )
      end
    end
  end

  context 'user role' do
    permissions :index?, :create?, :show? do
      it 'grants access' do
        expect(subject).to permit(user, admin.recipes.sample)
      end
    end

    permissions :update?, :destroy? do
      it "grants access only to it's own recipes" do
        expect(subject).to permit(user, user.recipes.sample)
      end

      it "denies access to other's recipes" do
        expect(subject).not_to permit(user, admin.recipes.sample)
      end
    end
  end

  context 'guest role' do
    permissions :create?, :update?, :destroy? do
      it 'denies access to the recipe' do
        expect(subject).not_to permit(guest, user.recipes.sample)
      end
    end

    permissions :index?, :show? do
      it 'grants access to recipes' do
        expect(subject).to permit(guest, user.recipes.sample)
        expect(subject).to permit(guest, admin.recipes.sample)
      end
    end
  end
end
