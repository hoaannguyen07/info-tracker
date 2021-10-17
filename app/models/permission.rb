class Permission < ApplicationRecord
    validates :description, presence: true

    # description cannot have any special characters besides '-' and '_' and spaces
    validates :description,
                format: {
                    with: /\A[A-Za-z\d\-_ ]*\z/,
                    message: "Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"
                }
end
