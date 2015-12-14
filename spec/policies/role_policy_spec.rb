require 'rails_helper'

RSpec.describe RolePolicy do

  let (:admin) { create(:brewmaster, :admin, :with_recipes) }
  let (:user) { create(:brewmaster, :user, :with_recipes) }
  let (:guest) { create(:brewmaster) }
  let (:role) { Role.new(name: 'tst_role', display_name: 'Test Role') }

  subject { described_class }

  context "admin role" do
    permissions :index?, :create?, :show?, :update?, :destroy? do
      it "grants access" do
        expect(subject).to permit(admin, role)
      end
    end
  end

  context "other roles" do
    permissions :index?, :create?, :show?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(user, role)
        expect(subject).not_to permit(guest, role)
      end
    end
  end
end
