class AddInitializedToGames < ActiveRecord::Migration
  def change
    add_column :games, :initialized, :boolean, :default => false
  end
end
