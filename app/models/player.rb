class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :hunter, :class_name => 'Player', :foreign_key => 'hunter_id'
  has_one :target, :class_name => 'Player', :foreign_key => 'hunter_id'
end
