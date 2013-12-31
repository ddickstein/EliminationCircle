class Game < ActiveRecord::Base
  has_many :players, :dependent => :destroy
  belongs_to :user
end
