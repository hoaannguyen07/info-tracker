# frozen_string_literal: true

class Event < ApplicationRecord
  validates :name, :time, presence: true
end
