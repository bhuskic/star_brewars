FactoryGirl.define do
  factory :grocery do
    sequence(:name, 0) { |n| "Grocery #{n}" }
    sequence(:grocery_type, 0) { |n| %w(Malt Hops Yeast Spices)[n % 4] }
    characteristics { Faker::DizzleIpsum.sentence }
  end
end
