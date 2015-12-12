require 'rails_helper'

RSpec.describe Role, type: :model do
  let (:role) { create(:guest_role) }

  context "role attributes" do
    it { should respond_to :name}
    it { should respond_to :display_name}
  end

  context "attribute validations" do
    describe "#name" do
      it "should have a value" do
        role.name = nil
        expect(role).not_to be_valid
      end

      it "should be unique" do
        dup_role = Role.new(name: role.name, display_name: "dup")
        expect(dup_role.save).to be false
        expect{ dup_role.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "should have case insensitive uniqueness" do
        dup_role = Role.new(name: role.name.swapcase!, display_name: "dup")
        expect(dup_role.save).to be false
        expect{ dup_role.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "shouldn't accept all characters" do
        role.name = "member_#2*"
        expect(role).not_to be_valid
      end

      it "should contain only chars, number, hyphen and underscore" do
        role.display_name = "new_role_1-name"
        expect(role).to be_valid
      end

      it "should be more than 3 characters long" do
        role.name = "aa"
        expect(role).not_to be_valid
      end

      it "shouldn't be more than 30 characters long" do
        role.name = ""
        31.times { role.name << "a" }
        expect(role).not_to be_valid
      end

    end

    describe "#display_name" do
      it "should have a value" do
        role.display_name = nil
        expect(role).not_to be_valid
      end

      it "should be unique" do
        dup_role = Role.new(name: "dup", display_name: role.display_name)
        expect{ dup_role.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "should have case insensitive uniqueness" do
        dup_role = Role.new(name: "dup", display_name: role.display_name.swapcase!)
        expect{ dup_role.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "shouldn't accept all characters" do
        role.display_name = "member_$%1!"
        expect(role).not_to be_valid
      end

      it "should contain only chars, number, spaces, hyphen and underscore" do
        role.display_name = "New role 1-name_role"
        expect(role).to be_valid
      end

      it "should be more than 3 characters long" do
        role.display_name = "aa"
        expect(role).not_to be_valid
      end

      it "shouldn't be more than 50 characters long" do
        role.display_name = ""
        51.times { role.display_name << "a" }
        expect(role).not_to be_valid
      end
    end
  end
end
