FactoryGirl.define do
  random_sample = -> do
    ("a".."z").to_a.sample(2).join
  end

  guest_role_created = -> do
    Role.exists?(name: 'brewmaster_padawan')
  end

  factory :user do
    pwd = Faker::Internet.password

    name { Faker::Internet.user_name << random_sample.call }
    email { random_sample.call << Faker::Internet.email }
    password  { pwd }
    password_confirmation { pwd }

    before(:create) do
      create(:guest_role) unless guest_role_created.call
    end
  end

end

