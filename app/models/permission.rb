# frozen_string_literal: true

class Permission < ApplicationRecord
  # description cannot have any special characters besides '-' and '_' and spaces
  validates :description, presence: true,
                          format: {
                            with: /\A[A-Za-z\d\-_ ]*\z/,
                            message: "cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"
                          }
  has_many :user_permissions, class_name: 'PermissionUser', foreign_key: 'permissions_id_id', dependent: :destroy, inverse_of: :permissions_id

  def self.admin_permission?(cur_perm)
    cur_perm.description == 'admin'
  end

  def self.exist?(cur_perm)
    !cur_perm.nil?
  end
end
