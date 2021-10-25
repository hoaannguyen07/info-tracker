# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Permission, type: :model) do
  subject(:test_permission) do
    described_class.new(description: 'test-permission')
  end

  context 'with Permission attribute(s)' do
    it 'is valid with valid description' do
      expect(test_permission).to(be_valid)
    end

    it 'is invalid with an empty description' do
      test_permission.description = nil
      expect(test_permission).not_to(be_valid)
    end

    it 'is invalid with an invalid permission' do
      test_permission.description = "!@#$%^&*()"
      expect(test_permission).not_to(be_valid)
    end
  end
end
