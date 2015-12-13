require 'rails_helper'

RSpec.describe RolePermission do
  context "messages" do
    it { should respond_to :name }
    it { should respond_to :policy_name }
    it { should respond_to :policy_scope }
    it { should respond_to :role}
  end

  context "attribute validations" do
    describe "#name" do
      it "is not valid without a name" do
        expect(RolePermission.new(name: "", policy_name: "UserPolicy")).not_to be_valid
      end
    end

    describe "#policy_name" do
      it "is not valid without a name" do
        expect(RolePermission.new(name: "index?", policy_name: "")).not_to be_valid
      end
    end
  end
end
