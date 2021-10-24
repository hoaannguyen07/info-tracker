class AddCreatedUpdatedByToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :created_by, :bigint
    add_column :events, :updated_by, :bigint
    add_foreign_key :events, :admins, column: :created_by, on_delete: :nullify
    add_foreign_key :events, :admins, column: :updated_by, on_delete: :nullify
  end
end
