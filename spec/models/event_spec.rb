# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Event, type: :model) do
  # pending "add some examples to (or delete) #{__FILE__}"

  subject(:test_event) do
    described_class.new(name: 'Tournament', description: 'Gig Em', location: 'Texas A&M', time: '2021-10-18 23:38:00 CDT CDT')
  end

  context 'with Event attribute(s)' do
    it 'is valid with all valid attributes with no empty fields' do
      expect(test_event).to(be_valid)
    end
  end

  # TESTING NAME FIELD
  context 'when NAME' do
    it 'is NOT valid without a name' do
      test_event.name = nil

      expect(test_event).not_to(be_valid)
    end
  end

  # TESTING DESCRIPTION FIELD
  context 'when DESCRIPTION' do
    it 'is valid with no description input' do
      test_event.description = nil
      expect(test_event).to(be_valid)
    end

    it 'is valid with any input' do
      # includes all characters, including newline, tab, and spaces
      test_event.description = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
      expect(test_event).to(be_valid)
    end
  end

  # TESTING LOCATION FIELD
  context 'when LOCATION' do
    it 'is valid with no location input' do
      test_event.location = nil
      expect(test_event).to(be_valid)
    end

    it 'is valid with any input' do
      # includes all characters, including newline, tab, and spaces
      test_event.location = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
      expect(test_event).to(be_valid)
    end
  end

  # TESTING TIME FIELD
  context 'when TIME' do
    it 'is NOT valid without a time' do
      test_event.time = nil

      expect(test_event).not_to(be_valid)
    end
  end
end
