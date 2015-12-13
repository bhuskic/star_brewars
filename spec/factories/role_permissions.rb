FactoryGirl.define do
  factory :role_permission do
    name "show?"
    policy_name "UserPolicy"
    policy_scope nil
  end
end
