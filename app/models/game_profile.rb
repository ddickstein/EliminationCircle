class GameProfile < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :hunter, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  has_one :target, :class_name => 'GameProfile', :foreign_key => 'hunter_id'
  
  before_validation :store_user_names_as_game_profile_names
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :game_id, :presence => true
  validates :user_id, :presence => true
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def mobile
    self.user.present? ? self.user.mobile : nil
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
    end
end
