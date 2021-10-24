# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(PermissionUser, type: :model) do
  subject(:test_permission_user) do
    described_class.new(user_id_id: test_admin.id, permissions_id_id: test_permission.id, created_by_id: test_admin.id, updated_by_id: test_admin.id)
  end

  let(:test_admin) { Admin.create!(email: 'tamu@gmail.com', full_name: 'Texas A&M', uid: '654cba321', avatar_url: 'www.example.com') }
  let(:test_permission) { Permission.create!(description: 'admin') }

  context 'with Permission User attribute(s)' do
    it 'is valid with valid attributes' do
      expect(test_permission_user).to(be_valid)
    end
  end
end
