class AddDefaultValueToPlayerKills < ActiveRecord::Migration
  def up
      change_column :players, :kills, :integer, :default => 0
  end

  def down
      change_column :players, :kills, :integer, :default => nil
  end
end
