class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.belongs_to :admin
      t.string :name
      t.integer :played
      t.integer :wins
      t.text :strengths
      t.text :weaknesses
      t.text :additional_info

      t.timestamps
    end
  end
end
