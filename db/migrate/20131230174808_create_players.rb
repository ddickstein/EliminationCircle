class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :details, :null => true
      t.integer :kills
      t.boolean :is_alive, :default => true
      t.integer :hunter_id
      t.integer :game_id

      t.timestamps
    end
    add_index :players, :game_id
    add_index :players, :hunter_id
  end
end
