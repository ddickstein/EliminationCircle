class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :hunter, :class_name => 'Player', :foreign_key => 'hunter_id'
  has_one :target, :class_name => 'Player', :foreign_key => 'hunter_id'
  
  validates :name, :presence => true
  validates :game_id, :presence => true
  
  scope :living, -> do
    where(is_alive: true).order('last_name ASC, first_name ASC')
  end
  
  scope :fallen, -> do
    where(is_alive: false).order('kills DESC, last_name ASC, first_name ASC')
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
