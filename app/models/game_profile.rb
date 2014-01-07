class GameProfile < ActiveRecord::Base
  include MobileConcern
  include NameConcern
  
  belongs_to :game
  belongs_to :user
  belongs_to :hunter, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  has_one :target, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  
  before_save :store_user_names_as_game_profile_names
  before_save :store_user_mobile_as_game_profile_mobile

  validates :game_id, :presence => true
  
  def first_name
    self.user.present? ? self.user.first_name : self.read_attribute(:first_name)
  end
  
  def last_name
    self.user.present? ? self.user.last_name : self.read_attribute(:last_name)
  end
  
  def mobile
    self.user.present? ? self.user.mobile : self.read_attribute(:mobile)
  end
  
  def email
    self.user.present? ? self.user.email : nil
  end
  
  private
  
    def store_user_names_as_game_profile_names
      if self.first_name.nil? and self.user.present?
        self.first_name = self.user.first_name
      end
      
      if self.last_name.nil? and self.user.present?
        self.last_name = self.user.last_name
      end
      
      format_names_nicely
    end
    
    def store_user_mobile_as_game_profile_mobile
      if self.mobile.nil? and self.user.present?
        self.mobile = self.user.mobile
      end
    end
end
