# frozen_string_literal: true

# https://api.rubyonrails.org/v5.1.7/classes/ActiveModel/Validations/ClassMethods.html
class Player < ApplicationRecord
  belongs_to :admin

  validates :admin_id, :name, :losses, :wins, presence: true

  # name cannot have any special characters besides '-' and '_' and spaces
  validates :name,
            format: {
              with: /\A[A-Za-z\d\-_ ]*\z/,
              message: "Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"
            }

  # played & wins needs to be a positive integer that is within integer bounds
  validates :losses, :wins, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 2_147_483_647,
    message: 'values must be between 0 and 2,147,483,647'
  }

  # can't have wins > played b/c you can't win without playing
  # validate :played_at_least_equal_wins

  # def played_at_least_equal_wins
  #   errors.add(:played, 'cannot be less than wins') unless wins && played && played >= wins
  # end
end
