require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { create(:brewmaster) }

  context "messages" do
    it { should respond_to :email }
    it { should respond_to :name }
    it { should respond_to :roles}
    it { should respond_to :recipes}
  end

  context "attribute validations" do
    it "is not valid without name" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "should have name longer than 3 characters" do
      user.name = "aa"
      expect(user).not_to be_valid
    end

    it "should have name shorter than 30 characters" do
      31.times { user.name << "a" }
    end

    it "should have unique name" do
      user_with_same_name = User.new(name: user.name, email: "some@mail.com")
      expect{ user_with_same_name.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is not valid without email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "should have valid email" do
      user.email = "usermail.com"
      expect(user).not_to be_valid
    end

    it "should have unique email" do
      user_with_same_email = User.new(name: "dup_email_user", email: user.email)
      expect{ user_with_same_email.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context "user roles" do
    context "new user" do
      it "should have at least one role assigned" do
        expect(user.roles).not_to be_empty
      end
      it "should have public role assigned" do
        expect(user.roles.collect(&:name)).to include 'brewmaster_padawan'
      end
    end
  end
end
