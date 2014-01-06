class AddPreregisteredToGames < ActiveRecord::Migration
  def change
    add_column :games, :preregistered, :boolean, :default => false
  end
end
