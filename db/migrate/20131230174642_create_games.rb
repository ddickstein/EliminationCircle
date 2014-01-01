class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, :null => false
      t.string :permalink, :null => false
      t.boolean :is_alive, :default => true
      t.integer :user_id

      t.timestamps
    end
    add_index :games, :permalink, :unique => true
    add_index :games, :user_id
  end
end
