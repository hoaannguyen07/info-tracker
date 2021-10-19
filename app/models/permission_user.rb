class PermissionUser < ApplicationRecord
  belongs_to :user_id, class_name: 'Players'
  belongs_to :created_by, class_name: 'Players'
  belongs_to :updated_by, class_name: 'Players'
  belongs_to :permissions_id, class_name: 'Permissions'
end
