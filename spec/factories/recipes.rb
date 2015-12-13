FactoryGirl.define do
  factory :recipe do
    sequence(:name,0) { |n| n.even? ? "Wonderful Ale beer_#{n}" : "Amazing Lager beer_#{n}" }
    sequence(:beer_style,0) { |n|
      n.even? ?
        ['Pale Ale', 'Belgian Tripel', 'Belgian Saison', 'Robust Porter', 'Dry Stout'].sample :
        ['Checz Pilsner', 'Munchner Helle', 'Bock Bier', 'Eisbock', 'Schwarz bier'].sample
    }
    sequence(:beer_type,0) { |n| n.even? ? 'Ale' : 'Lager' }
  end

  factory :pale_ale_recipe, class: Recipe do
    name 'Sunny Pale Ale'
    beer_style 'American Pale Ale'
    beer_type 'Ale'
    procedure_description ''
  end

  factory :india_pale_ale_recipe, class: Recipe do
    name 'As bitter as it can be'
    beer_style 'American Pale Ale'
    beer_type 'Ale'
    procedure_description ''
  end

  factory :belgian_tripel_recipe, class: Recipe do
    name 'Triple the trouble'
    beer_style 'Belgian Tripel'
    beer_type 'Ale'
    procedure_description ""
  end

  factory :pilsner_recipe, class: Recipe do
    name 'From Bohemia with love'
    beer_style 'Checz pilsner'
    beer_type 'Lager'
    procedure_description ""
  end

  factory :helle_recipe, class: Recipe do
    name 'Ein kleine bier'
    beer_style 'Munich Helle'
    beer_type 'Lager'
    procedure_description ""
  end
end
