class AddFirstAndLastNameToGameProfiles < ActiveRecord::Migration
  def change
    add_column :game_profiles, :first_name, :string
    add_column :game_profiles, :last_name, :string
  end
end
