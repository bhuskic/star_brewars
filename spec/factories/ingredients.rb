FactoryGirl.define do
  factory :ingredient do
    grocery
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
