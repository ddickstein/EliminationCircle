class Game < ActiveRecord::Base
  attr_accessor :preregistered, :player_sheet, :parameter_lists
  
  has_many :game_profiles, :dependent => :destroy
  belongs_to :user
  
  validates :name, :presence => true
  validates :user_id, :presence => true
  # validate  :has_valid_csv_sheet
  
  before_create :generate_permalink
  # before_create :clean_csv_format_and_details_columns
  # after_create :create_players
  
  def to_param
    self.permalink
  end
  
  def is_alive?
    self.players.where(is_alive: true).count > 1
  end

  def is_dead?
    not is_alive?
  end
  
  def players
    self.game_profiles
  end
  
  private
    # def clean_csv_format_and_details_columns
    #   self.csv_format.chomp!(",")
    #   self.csv_format = self.csv_format.split(",").map(&:strip)
    #   self.csv_format = self.csv_format.map(&:capitalize).join(",")
    #   if self.details_columns.present?
    #     self.details_columns.chomp!(",")
    #     cols = self.details_columns.split(",").map(&:strip).map(&:capitalize)
    #     self.details_columns = cols.join(',')
    #   end
    # end
  
    def generate_permalink
      loop do
        prefix_rand_base36 = rand(0..1295).to_s(36)
        suffix_rand_base36 = rand(0..1295).to_s(36)
        rand_time = Time.zone.now.to_i.to_s(36).slice(2..-1)
        new_permalink = prefix_rand_base36 + rand_time + suffix_rand_base36
        if Game.find_by(new_permalink).nil?
          self.permalink = new_permalink
          break
        end
      end
    end
    
    # def has_valid_csv_sheet
    #   if self.csv_format.empty?
    #     self.errors[:base] << "No format specified"
    #   elsif (not self.csv_format.start_with? "First, Last" and
    #         not self.csv_format.start_with? "Last, First") or
    #         self.csv_format =~ /,\s*,/
    #     self.errors[:base] << "Invalid format specified"
    #   elsif self.csv_sheet.empty?
    #     self.errors[:base] << "No players specified"
    #   else
    #     num_commas = self.csv_format.chomp(",").count(",")
    #     rows = self.csv_sheet.split("\n").map(&:strip)
    #     rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
    #     if rows.size < 2
    #       self.errors[:base] << "Fewer than two players specified"
    #     else
    #       rows.keep_if do |row|
    #         row.chomp(",").count(",") != num_commas or
    #         row =~ /(?:^\s*,)|(?:,\s*,)/
    #       end
    #       if rows.size > 0
    #         self.errors[:base] << "Bad format on line \"#{rows[0]}\""
    #       end
    #     end
    #   end
    # end
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
