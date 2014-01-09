class Game < ActiveRecord::Base
  include Shuffler
  
  attr_accessor :player_sheet, :parameter_lists
  
  has_many :game_profiles, :dependent => :destroy
  belongs_to :user
  
  PLAYER_REGEX = /\A[a-zA-Z]+\s+[a-zA-Z]+(?:\s+[a-zA-Z]+)*?
                 (?:\s*,\s*(?:1\s*-?\s*)?(?:\([2-9]\d\d\)|
                 [2-9]\d\d)\s*-?\s*(?:\d\d\d)\s*-?\s*(?:\d\d\d\d))?\s*,?\z/x

  validates :name, :presence => true
  validates :user_id, :presence => true
  validates :preregistered, :inclusion => {:in => [true,false]}
  validates :player_sheet, :presence => true, :if => :preregistered?
  validate  :has_valid_player_sheet

  before_create :generate_permalink
  after_create :create_players, :if => :preregistered?
  
  def to_param
    self.permalink
  end

  def status
    case
    when pending? then 'pending'
    when progressing? then 'in progress'
    when finished? then 'finished'
    else nil
    end
  end
  
  def start
    save if new_record?
    return false if started? or not valid? or players.count < 2
    create_circle
    distribute_parameters
    self.started = true
    save
  end
  
  def pending?
    not started?
  end

  def progressing?
    started? and self.players.where(is_alive: true).count > 1
  end

  def finished?
    not pending? and not progressing?
  end
  
  def players
    self.game_profiles.order('last_name asc, first_name asc')
  end
  
  private
    def generate_permalink
      loop do
        prefix_rand_base36 = rand(0..1295).to_s(36)
        suffix_rand_base36 = rand(0..1295).to_s(36)
        rand_time = Time.zone.now.to_i.to_s(36).slice(2..-1)
        new_permalink = prefix_rand_base36 + rand_time + suffix_rand_base36
        if Game.find_by(permalink: new_permalink).nil?
          self.permalink = new_permalink
          break
        end
      end
    end
    
    def has_valid_player_sheet
      if self.player_sheet.present?
        rows = self.player_sheet.split("\n").map(&:strip)
        rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
        if rows.size < 2
          self.errors[:base] << "Fewer than two players specified"
        else
          rows.each do |row|
            if row !~ PLAYER_REGEX
              self.errors[:base] << "Bad format on line \"#{row}\""
              break
            end
          end
        end
      end
    end
    
    def create_players
      rows = self.player_sheet.split("\n").map(&:strip)
      rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
      rows.each do |row|
        name,phone = row.split(',').map(&:strip)
        player = GameProfile.new
        player.game = self
        name_arr = name.split(/\s+/)
        player.first_name = name_arr[0]
        player.last_name = name_arr[1..-1].join(" ")
        player.mobile = phone unless phone.nil?
        player.save!
      end
    end
    
    def create_circle
      first_player = nil
      most_recent_player = nil
      players.shuffle.each do |player|
        if first_player.nil?
          first_player = player
          most_recent_player = player
        else
          player.hunter = most_recent_player
          player.save!
          most_recent_player = player
        end
      end
      first_player.hunter = most_recent_player
      first_player.save!
    end
    
    def distribute_parameters
      if self.parameter_lists.present?
        num_players = players.count
        detail_sets = self.parameter_lists.map { |name,list|
          Shuffler.shuffle_to_length(list,num_players)
        }.transpose.map{|set| set.join(", ")}
        players.each_with_index do |player,index|
          player.details = detail_sets[index]
          player.save!
        end
      end
    end
end
