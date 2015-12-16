class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { within: 3..30 },
      format: { with: /\A[\w\-\.]+\z/i, on: :create }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
      format: { with: /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password_confirmation, presence: true, if: '!password.nil?'

  has_and_belongs_to_many :roles
  has_many :recipes, dependent: :destroy

  after_create :set_default_role
  before_create :set_auth_token

  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end


  private

  def set_default_role
    if self.roles.empty?
      self.roles << Role.find_by(name: 'brewmaster_padawan')
    end
  end

  def generate_auth_token
    SecureRandom.urlsafe_base64
  end

end
