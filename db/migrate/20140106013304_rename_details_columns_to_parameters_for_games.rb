class RenameDetailsColumnsToParametersForGames < ActiveRecord::Migration
  def change
    rename_column :games, :details_columns, :parameters
  end
end
