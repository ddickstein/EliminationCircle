class RemoveIsAliveFromGames < ActiveRecord::Migration
  def up
    remove_column :games, :is_alive
  end

  def down
    add_column :games, :is_alive, :boolean, :default => true
  end
end
