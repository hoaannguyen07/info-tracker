class Event < ApplicationRecord
  validates :name, :time, presence: true
end
