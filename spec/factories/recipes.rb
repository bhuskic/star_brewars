FactoryGirl.define do
  factory :recipe do
    sequence(:name,0) { |n| n.even? ? "Wonderful Ale beer_#{n}" : "Amazing Lager beer_#{n}" }
    sequence(:beer_style,0) { |n|
      n.even? ?
        ['Pale Ale', 'Belgian Tripel', 'Belgian Saison', 'Robust Porter', 'Dry Stout'].sample :
        ['Checz Pilsner', 'Munchner Helle', 'Bock Bier', 'Eisbock', 'Schwarz bier'].sample
    }
    sequence(:beer_type,0) { |n| n.even? ? 'Ale' : 'Lager' }

    trait :with_ingredients do
      after(:create) do |recipe, evaluator|
        create_list(:ingredient, rand(4..12), recipe: recipe)
      end
    end
  end
end
