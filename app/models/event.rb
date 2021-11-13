# frozen_string_literal: true

class Event < ApplicationRecord
  validates :name, :time, presence: true

  def self.exist?(cur_event)
    !cur_event.nil?
  end
end
