class AddDetailsColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :details_columns, :string
  end
end
