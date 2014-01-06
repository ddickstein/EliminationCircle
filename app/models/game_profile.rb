class GameProfile < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :hunter, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  has_one :target, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  
  before_save :store_user_names_as_game_profile_names
  before_save :store_user_mobile_as_game_profile_mobile
  
  PHONE_REGEX = /\A(?:1\s*-?\s*)?(?<area>\([2-9]\d\d\)|[2-9]\d\d)\s*-?\s*
                (?<num1>\d\d\d)\s*-?\s*(?<num2>\d\d\d\d)\z/x

  validates :mobile,     :format => { :with => PHONE_REGEX }
  validates :game_id,    :presence => true
  validates :user_id,    :presence => true
  
  def full_name
    if self.user.present?
      self.user.full_name
    else
      "#{self.first_name} #{self.last_name}"
    end
  end
  
  def mobile
    self.user.present? ? self.user.mobile : nil
  end
  
  def email
    self.user.present? ? self.user.email : nil
  end
  
  private
  
    def store_user_names_as_game_profile_names
      if self.user.present?
        puts "USER IS HERE"
      end
      
      
      if self.first_name.nil? and self.user.present?
        self.first_name = self.user.first_name
      end
      
      if self.last_name.nil? and self.user.present?
        self.last_name = self.user.last_name
      end
    end
    
    def store_user_mobile_as_game_profile_mobile
      if self.user.present?
        puts "USER IS HERE"
      end
      
      if self.mobile.nil? and self.user.present?
        self.mobile = self.user.mobile
      end
    end
end
