class AddMobileToGameProfiles < ActiveRecord::Migration
  def change
    add_column :game_profiles, :mobile, :string
  end
end
