# frozen_string_literal: true

class PermissionUser < ApplicationRecord
  belongs_to :user_id, class_name: 'Admin'
  belongs_to :created_by, class_name: 'Admin'
  belongs_to :updated_by, class_name: 'Admin'
  belongs_to :permissions_id, class_name: 'Permission'
end
