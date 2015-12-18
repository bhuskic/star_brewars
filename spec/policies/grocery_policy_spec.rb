require 'rails_helper'

RSpec.describe GroceryPolicy do
  
  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:user) { create(:brewmaster, :user, :with_recipes) }
  let (:guest) { create(:brewmaster) }
  let (:grocery) { Grocery.new( name: 'Amarillo', grocery_type: 'Hops', characteristics: 'Hops with fruity, citrusy aroma with...') }

  subject { described_class }

  context 'admin role' do
    permissions :index?, :show?, :create?, :update?, :destroy? do
      it 'grants access' do
        expect(subject).to permit(admin, grocery)
      end
    end
  end

  context 'other roles' do
    permissions :index?, :show?, :create?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(user, grocery)
        expect(subject).not_to permit(guest, grocery)
      end
    end
  end
end
