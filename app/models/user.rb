class User < ActiveRecord::Base
  attr_accessor :name
  
  has_many :games, :dependent => :destroy
  has_many :game_profiles
  
  has_secure_password :validations => false
  
  NAME_REGEX = /\A[a-zA-Z]+\s+[a-zA-Z\s]+\z/
  
  # Email regex from Michael Hartl's tutorial
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i 
  
  PHONE_REGEX = /\A(?:1\s*-?\s*)?(?<area>\([2-9]\d\d\)|[2-9]\d\d)\s*-?\s*
                (?<num1>\d\d\d)\s*-?\s*(?<num2>\d\d\d\d)\z/x
  
  validates :name, :presence => true, :format => { :with => NAME_REGEX }
  validates :email, :presence => true, :format => { :with => EMAIL_REGEX },
                    :uniqueness => { case_sensitive: false }
  validates :mobile, :presence => true, :format => { :with => PHONE_REGEX },
                     :uniqueness => true
  validates :password, :presence => true, :length => { minimum: 6 },
                       :confirmation => true, :on => :create
  validates :password, :presence =>true, :length => { minimum: 6 },
                       :confirmation => true, :on =>:update,
                       :if => :setting_password?

  before_save { self.email = email.downcase }
  before_save :reformat_mobile_number
  before_save :split_name_into_first_and_last
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private
    def setting_password?
      self.password.present? or self.password_confirmation.present?
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def reformat_mobile_number
      area, num1, num2 = PHONE_REGEX.match(self.mobile).to_a[1..3]
      if area =~ /\([2-9]\d\d\)/
        self.mobile = "1 #{area} #{num1} - #{num2}"
      else
        self.mobile = "1 (#{area}) #{num1} - #{num2}"
      end
    end
    
    def split_name_into_first_and_last
      partition = self.name.partition(' ')
      self.first_name = partition[0]
      self.last_name = partition[2]
    end

end