FactoryGirl.define do
  factory :ingredient do
    sequence(:name, 0) { |n| "Ingredient #{n}" }
    sequence(:type_name, 0) { |n| %w(Malt Hops Yeast Spices)[n % 4] }
    sequence(:amount, 0) { |n|
      [
        "#{rand(250..6000)} g",
        "#{rand(5..75)}g",
        "1l starter",
        "#{rand(1..14)}g"
      ][n % 4]
    }
  end
end
