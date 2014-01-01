class Game < ActiveRecord::Base
  attr_accessor :csv_format, :csv_sheet, :randomize_details
  
  has_many :players, :dependent => :destroy
  belongs_to :user
  
  validates :name, :presence => true
  validate :has_valid_csv_sheet
  
  before_create :generate_permalink
  before_create :clean_csv_format_and_details_title
  after_create :create_players
  
  def to_param
    self.permalink
  end
  
  private
    def clean_csv_format_and_details_title
      self.csv_format.chomp!(",")
      self.csv_format = self.csv_format.split(",").map(&:strip).join(",")
      self.details_title.chomp!(",")
      self.details_title = self.details_title.split(",").map(&:strip).join(",")
    end
  
    def generate_permalink
      prefix_rand_base36 = rand(0..1295).to_s(36)
      suffix_rand_base36 = rand(0..1295).to_s(36)
      rand_time = Time.zone.now.to_i.to_s(36).slice(2..-1)
      self.permalink = prefix_rand_base36 + rand_time + suffix_rand_base36
    end
    
    def has_valid_csv_sheet
      if self.csv_format.empty?
        self.errors[:base] << "No format specified"
      elsif (not self.csv_format.start_with? "First, Last" and
            not self.csv_format.start_with? "Last, First") or
            self.csv_format =~ /,\s*,/
        self.errors[:base] << "Invalid format specified"
      elsif self.csv_sheet.empty?
        self.errors[:base] << "No players specified"
      else
        num_commas = self.csv_format.chomp(",").count(",")
        rows = self.csv_sheet.split("\n").map(&:strip)
        rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
        rows.keep_if do |row|
          row.chomp(",").count(",") != num_commas or row =~ /,\s*,/
        end
        if rows.size > 0
          self.errors[:base] << "Bad format on line \"#{rows[0]}\""
        end
      end
    end
    
    def create_players
      headers = self.csv_format.split(",")
      rows = self.csv_sheet.split("\n").map(&:strip).map{|row| row.split(",")}
      rows.each do |row|
        if headers[0] == 'First'
          first_name = row[0]
          last_name = row[1]
        else
          first_name = row[1]
          last_name = row[0]
        end
        full_name = first_name.capitalize + ' ' + last_name.capitalize
        
      end
    end
end
