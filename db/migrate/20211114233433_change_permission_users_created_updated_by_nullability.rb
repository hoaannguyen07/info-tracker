class ChangePermissionUsersCreatedUpdatedByNullability < ActiveRecord::Migration[6.1]
  def change
    change_column_null :permission_users, "created_by_id", true
    change_column_null :permission_users, "updated_by_id", true
    
    remove_foreign_key :permission_users, column:"user_id_id"
    remove_foreign_key :permission_users, column:"created_by_id"
    remove_foreign_key :permission_users, column:"updated_by_id"
    remove_foreign_key :permission_users, column:"permissions_id_id"

    add_foreign_key :permission_users, :admins, column: "user_id_id", on_delete: :cascade
    add_foreign_key :permission_users, :admins, column: "created_by_id", on_delete: :nullify
    add_foreign_key :permission_users, :admins, column: "updated_by_id", on_delete: :nullify
    add_foreign_key :permission_users, :permissions, column: "permissions_id_id", on_delete: :cascade
  end
end
