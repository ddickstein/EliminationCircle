class User < ActiveRecord::Base
  has_many :games, :dependent => :destroy
  
  has_secure_password :validations => false
  
  validates :name, :presence => true
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => EMAIL_REGEX},
                    :uniqueness => { case_sensitive: false }
  validates :password, :presence => true, :length => { minimum: 6},
                       :confirmation => true, :if => :setting_password?

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def setting_password?
      self.password.present? or self.password_confirmation.present?
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end