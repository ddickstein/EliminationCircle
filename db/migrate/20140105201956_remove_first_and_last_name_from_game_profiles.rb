class RemoveFirstAndLastNameFromGameProfiles < ActiveRecord::Migration
  def up
    remove_column :game_profiles, :first_name
    remove_column :game_profiles, :last_name
  end

  def down
    add_column :game_profiles, :first_name, :string
    add_column :game_profiles, :last_name, :string
  end
end
