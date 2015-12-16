class Ingredient < ActiveRecord::Base
  validates_presence_of :name, :type_name, :amount

  belongs_to :recipe
end
