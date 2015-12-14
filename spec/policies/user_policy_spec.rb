require 'rails_helper'

RSpec.describe UserPolicy do
  let (:admin) { create(:brewmaster, :admin) }
  let (:user) { create(:brewmaster, :user) }
  let (:guest) { create(:brewmaster) }
  let (:new_user) { User.new(name: 'tst', email: 'tst@tst.com', password: 'pdw') }

  subject { described_class }

  context "admin role" do
    permissions :index?, :show?, :create?, :update?, :destroy? do
      it "grants full access only to brewmaster with admin role" do
        expect(subject).to permit(admin, new_user)
      end
    end
  end

  context "other roles" do
    permissions :index?, :create?, :update?, :destroy? do
      it "denies access to any other role" do
        expect(subject).not_to permit(user, guest)
        expect(subject).not_to permit(guest, user)
      end
    end

    permissions :show? do
      it "grants access only to own record for other roles" do
        expect(subject).to permit(user, user)
        expect(subject).to permit(guest, guest)
      end
    end
  end
end
