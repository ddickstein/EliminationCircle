class AddFirstAndLastNameToPlayers < ActiveRecord::Migration
  def up
    remove_column :players, :name
    add_column :players, :last_name, :string
    add_column :players, :first_name, :string
    add_index :players, :last_name
  end

  def down
    remove_column :players, :last_name
    remove_column :players, :first_name
    remove_index :players, :last_name
    add_column :players, :name, :string
  end
end
