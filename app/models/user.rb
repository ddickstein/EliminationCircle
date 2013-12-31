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

  private
    def setting_password?
      self.password.present? or self.password_confirmation.present?
    end

end
