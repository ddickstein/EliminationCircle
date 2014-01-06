class RenamePlayersToGameProfiles < ActiveRecord::Migration
  def change
      rename_table :players, :game_profiles
  end
end
