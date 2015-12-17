
policies = -> {
  %w(UserPolicy RolePolicy RecipePolicy IngredientPolicy)
}

FactoryGirl.define do
  factory :guest_role, class: Role do
    name "brewmaster_padawan"
    display_name "Brewmaster Padawan"

    trait :with_permissions do
      after(:create) do |role, evaluator|
        policies.call.each do |policy|
          unless policy == "RolePolicy"
            actions = if policy == "UserPolicy"
                        %w(show? update?)
                      else
                        %w(index? show?)
                      end
            actions.each do |action|
              policy_scope = "owner?" if %w(show? update?).include?(action) && policy == "UserPolicy"
              create(:role_permission,
                     role: role,
                     name: action,
                     policy_name: policy,
                     policy_scope: policy_scope)
            end
          end
        end
      end
    end
  end

  factory :user_role, class: Role do
    name "brewmaster_jedi"
    display_name "Brewmaster Jedi"

    trait :with_permissions do
      after(:create) do |role, evaluator|
        policies.call.each do |policy|
          unless policy == "RolePolicy"
            actions = if policy == "UserPolicy"
                        %w(show? update?)
                      elsif policy == "IngredientPolicy"
                        %w(index? show?)
                      else
                        %w(index? show? create? update? destroy?)
                      end
            actions.each do |action|
              policy_scope_required = (policy == "UserPolicy" && %w(show? update?).include?(action)) ||
                                        %w(update? destroy?).include?(action)
              policy_scope = "owner?" if policy_scope_required
              create(:role_permission,
                     role: role,
                     name: action,
                     policy_name: policy,
                     policy_scope: policy_scope)
            end
          end
        end
      end
    end
  end

  factory :admin_role, class: Role do
    name "brewmaster_yoda"
    display_name "Brewmaster Yoda"

    trait :with_permissions do
      after(:create) do |role, evaluator|
        policies.call.each do |policy|
          %w(index? show? create? update? destroy?).each do |action|
            create(:role_permission,
                   role: role,
                   name: action,
                   policy_name: policy)
          end
        end
      end
    end
  end
end
