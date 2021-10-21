# frozen_string_literal: true

class Image < ApplicationRecord
    has_one_attached :img

    validates :img, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
    validates :caption, presence: true, length: { maximum: 256 }
end
