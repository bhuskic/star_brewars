class Recipe < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :beer_type, :beer_style

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :grocery_ingredients, through: :ingredients
end
