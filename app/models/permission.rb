# frozen_string_literal: true

class Permission < ApplicationRecord
  # description cannot have any special characters besides '-' and '_' and spaces
  validates :description, presence: true,
            format: {
              with: /\A[A-Za-z\d\-_ ]*\z/,
              message: "Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"
            }
  has_many :user_permissions, class_name: 'PermissionUser', foreign_key: 'permissions_id_id', dependent: :destroy, inverse_of: :permissions_id
end
