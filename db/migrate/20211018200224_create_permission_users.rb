class CreatePermissionUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :permission_users do |t|
      t.references :user_id, null: false
      t.references :created_by, null: false
      t.references :updated_by, null: false
      t.references :permissions_id, null: false

      t.timestamps
    end

    add_foreign_key :permission_users, :players, column: "user_id_id"
    add_foreign_key :permission_users, :players, column: "created_by_id"
    add_foreign_key :permission_users, :players, column: "updated_by_id"
    add_foreign_key :permission_users, :permissions, column: "permissions_id_id" 
  end
end
