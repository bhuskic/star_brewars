random_sample = -> {
  ("a".."z").to_a.sample(2).join
}
FactoryGirl.define do
  factory :recipe do
    sequence(:name,0) { |n| n.even? ? "Wonderful Ale beer_#{n}_#{random_sample}" : "Amazing Lager beer_#{n}_#{random_sample}" }
    sequence(:beer_style,0) { |n|
      n.even? ?
        ['Pale Ale', 'Belgian Tripel', 'Belgian Saison', 'Robust Porter', 'Dry Stout'].sample :
        ['Checz Pilsner', 'Munchner Helle', 'Bock Bier', 'Eisbock', 'Schwarz bier'].sample
    }
    sequence(:beer_type,0) { |n| n.even? ? 'Ale' : 'Lager' }
    sequence(:procedure_description,0) { |n| n.even? ? 'Single mash infusion at 63' : 'Multi mash infusion at 40, 60, 70 degrees' }

    after(:create) do |recipe, evaluator|
      #rand(4..7).times do |n|
      #  grocery = create(:grocery)
      #  create(:ingredient, grocery: grocery, recipe: recipe)
      #end
      create_list(:ingredient, rand(4..7), recipe: recipe)
    end
  end
end
