class AddUserIdToGameProfiles < ActiveRecord::Migration
  def change
    add_column :game_profiles, :user_id, :integer
    add_index :game_profiles, :user_id
  end
end
