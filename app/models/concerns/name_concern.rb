module NameConcern
  extend ActiveSupport::Concern

  def full_name
    "#{self.first_name} #{self.last_name}"
  end


  def format_names_nicely
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.split(" ").map(&:capitalize).join(" ")
  end
end