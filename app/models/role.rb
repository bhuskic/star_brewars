class Role < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { within: 3..30 },
    format: { with: /\A[\w\-]+\z/i, on: [:create, :update] }
  validates :display_name,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { within: 3..50 },
    format: { with: /\A[\w\s\-]+\z/i, on: [:create, :update] }

  has_and_belongs_to_many :users
end
