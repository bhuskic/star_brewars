class Grocery < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :grocery_type

  has_many :ingredients, dependent: :restrict_with_exception
  has_many :recipe_ingredients, through: :ingredients
end
