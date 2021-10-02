# https://api.rubyonrails.org/v5.1.7/classes/ActiveModel/Validations/ClassMethods.html
class Player < ApplicationRecord
    belongs_to :admin
    
    validates :admin_id, :name, :played, :wins, presence: true

    # name cannot have any special characters besides '-' and '_' and spaces
    validates :name, format: {with: /\A[A-Za-z\d\-\_ ]*\z/, message: "Cannot use any special characters other than spaces, '-', and '_'"}

    # played & wins needs to be a positive integer that is within integer bounds
    validates :played, :wins, numericality: {
        only_integer: true, 
        greater_than_or_equal_to: 0, 
        less_than_or_equal_to: 2147483647,
        message: "Played/Wins values must be between 0 and 2,147,483,647"
    }
    
    # can't have wins > played b/c you can't win without playing
    validate :played_at_least_equal_wins
    
    # admin_id is of bigint type and indices in the Admin table starts from 1 so admin_id needs to be a positive bigint
    validates :admin_id, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 9223372036854775807}

    private
        def played_at_least_equal_wins
            errors.add("Cannot win more games than played") unless (wins && played && played >= wins)
        end
end
