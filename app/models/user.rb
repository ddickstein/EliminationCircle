class User < ActiveRecord::Base
  include MobileConcern
  include NameConcern
  
  attr_accessor :name
  
  has_many :games, :dependent => :destroy
  has_many :game_profiles
  
  has_secure_password :validations => false
  
  NAME_REGEX = /\A[a-zA-Z]+\s+[a-zA-Z\s]+\z/
  
  # Email regex from Michael Hartl's tutorial
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i 
  
  validates :name, :presence => true, :format => { :with => NAME_REGEX }
  validates :email, :presence => true, :format => { :with => EMAIL_REGEX },
                    :uniqueness => { case_sensitive: false }
  validates :mobile, :uniqueness => true, :if => :mobile
  validates :password, :presence => true, :length => { minimum: 6 },
                       :confirmation => true, :on => :create
  validates :password, :presence =>true, :length => { minimum: 6 },
                       :confirmation => true, :on =>:update,
                       :if => :setting_password?

  before_save { self.email = email.downcase }
  before_save :split_name_into_first_and_last
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def playing? game
    game.user == self or GameProfile.find_by(
      user_id: self.id, game_id: game.id
    ).present?
  end

  private
    def setting_password?
      self.password.present? or self.password_confirmation.present?
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    
    def split_name_into_first_and_last
      if self.name.present?
        partition = self.name.partition(' ')
        self.first_name = partition[0]
        self.last_name = partition[2]
        format_names_nicely
      end
    end

end