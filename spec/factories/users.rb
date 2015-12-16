FactoryGirl.define do
  random_sample = -> {
    ("a".."z").to_a.sample(2).join
  }

  role_created = ->(name) {
    Role.exists?(name: name)
  }

  factory :brewmaster, class: User do
    pwd = Faker::Internet.password

    name { Faker::Internet.user_name << random_sample.call }
    email { random_sample.call << Faker::Internet.email }
    password  { pwd }
    password_confirmation { pwd }

    before(:create) do |user, evaluator|
      create(:guest_role, :with_permissions) unless role_created.call('brewmaster_padawan')
    end

    trait :admin do
      after(:create) do |brewmaster, evaluator|
        brewmaster.roles << if role_created.call('brewmaster_yoda')
                              Role.find_by(name: 'brewmaster_yoda')
                            else
                              create(:admin_role, :with_permissions)
                            end
      end
    end

    trait :user do
      after(:create) do |brewmaster, evaluator|
        brewmaster.roles << if role_created.call('brewmaster_jedi')
                              Role.find_by(name: 'brewmaster_jedi')
                            else
                              create(:user_role, :with_permissions)
                            end
      end
    end

    trait :with_recipes do
      after(:create) do |brewmaster, evaluator|
        #rand(4..8).times do 
        #  create(:recipe, user: brewmaster)
        #end
        create_list(:recipe, rand(4..8), user: brewmaster)
      end
    end
  end

end

