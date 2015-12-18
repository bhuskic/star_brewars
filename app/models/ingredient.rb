class Ingredient < ActiveRecord::Base
  validates_presence_of :amount

  belongs_to :grocery
  belongs_to :recipe

  delegate :name, :grocery_type, :characteristics, to: :grocery
end
