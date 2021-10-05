class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.belongs_to :admin, null: false
      t.string :name, null: false
      t.integer :played, null: false
      t.integer :wins, null: false
      t.text :strengths
      t.text :weaknesses
      t.text :additional_info

      t.timestamps
    end
  end
end
