class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { within: 3..30 },
      format: { with: /\A[\w\-\.]+\z/i, on: :create }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
      format: { with: /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password_confirmation, presence: true, if: '!password.nil?'

  has_and_belongs_to_many :roles

  after_create :set_default_role

  def set_default_role
    if self.roles.empty?
      self.roles << Role.find_by(name: 'brewmaster_padawan')
    end
  end

end
