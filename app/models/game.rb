class Game < ActiveRecord::Base
  attr_accessor :player_sheet, :parameter_lists
  
  has_many :game_profiles, :dependent => :destroy
  belongs_to :user
  
  PLAYER_REGEX = /\A\w+\s+\w+(?:\s*,\s*(?:1\s*-?\s*)?(?:\([2-9]\d\d\)|
                 [2-9]\d\d)\s*-?\s*(?:\d\d\d)\s*-?\s*(?:\d\d\d\d))?\s*,?\z/x

  validates :name, :presence => true
  validates :user_id, :presence => true
  validates :preregistered, :inclusion => {:in => [true,false]}
  validates :player_sheet, :presence => true, :if => :preregistered
  validate  :has_valid_player_sheet, :if => :preregistered
  
  before_create :generate_permalink
  after_create :create_players, :if => :preregistered
  after_commit :create_circle
  after_commit :distribute_parameters
  
  def to_param
    self.permalink
  end
  
  def status
    case
    when self.pending? then 'pending'
    when self.progressing? then 'in progress'
    when self.finished? then 'finished'
    else nil
    end
  end
  
  def pending?
    not started?
  end
  
  def progressing?
    started? and self.players.where(is_alive: true).count > 1
  end

  def finished?
    started? and not progressing?
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
    # 
    # def create_players
    #   headers = self.csv_format.split(",")
    #   
    #   rows = self.csv_sheet.split("\n").map(&:strip)
    #   rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
    #   rows.map!{|row| row.split(",").map(&:strip).map(&:capitalize) }
    #   
    #   if headers[0] == 'First'
    #     first_names, last_names, *details = rows.transpose
    #   else
    #     last_names, first_names, *details = rows.transpose
    #   end
    #   full_names = first_names.zip(last_names)
    #   
    #   if self.randomization_algorithm == 'None'
    #     details = details.transpose.map{|detail| detail.join(',')}
    #     elimination_circle = full_names.zip(details).map(&:flatten).shuffle
    #   elsif self.randomization_algorithm == 'Set'
    #     full_names.shuffle!
    #     details = details.transpose.map{|detail| detail.join(',')}
    #     elimination_circle = full_names.zip(details).map(&:flatten)
    #   else # Individual randomization
    #     full_names.shuffle!
    #     details = details.map(&:shuffle).transpose.map do |detail|
    #       detail.join(',')
    #     end
    #     elimination_circle = full_names.zip(details).map(&:flatten)
    #   end
    #   
    #   first_player = nil
    #   most_recent_player = nil
    #   elimination_circle.each do |row|
    #     p = GameProfile.new
    #     p.first_name = row[0]
    #     p.last_name = row[1]
    #     p.details = row[2]
    #     p.game = self
    #     p.hunter = most_recent_player
    #     p.save
    #     if first_player.nil?
    #       first_player = p
    #     end
    #     most_recent_player = p
    #   end
    #   first_player.hunter = most_recent_player
    #   first_player.save
    # end
end
