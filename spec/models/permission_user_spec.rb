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

    context 'when USER_ID_ID' do
      it 'is not valid without an id' do
        test_permission_user.user_id_id = nil
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an invalid user_id' do
        test_permission_user.user_id_id = 1_234_567_890
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an user_id_id that is a string' do
        test_permission_user.user_id_id = 'testing user_id'
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an user_id_id that is negative' do
        test_permission_user.user_id_id = -1
        expect(test_permission_user).not_to(be_valid)
      end
    end

    context 'when PERMISSIONS_ID_ID' do
      it 'is not valid without an id' do
        test_permission_user.permissions_id_id = nil
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an invalid permissions_id_id' do
        test_permission_user.permissions_id_id = 1_234_567_890
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an permissions_id_id that is a string' do
        test_permission_user.permissions_id_id = 'testing permissions_id_id'
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an permissions_id_id that is negative' do
        test_permission_user.permissions_id_id = -1
        expect(test_permission_user).not_to(be_valid)
      end
    end

    context 'when CREATED_BY_ID' do
      it 'is not valid without an id' do
        test_permission_user.created_by_id = nil
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an created_by_id that does not exist' do
        test_permission_user.created_by_id = 1_234_567_890
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an created_by_id that is a string' do
        test_permission_user.created_by_id = 'testing created_by_id'
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with an created_by_id that is negative' do
        test_permission_user.created_by_id = -1
        expect(test_permission_user).not_to(be_valid)
      end
    end

    context 'when UPDATED_BY_ID' do
      it 'is not valid without an id' do
        test_permission_user.updated_by_id = nil
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with a updated_by_id that does not exist' do
        test_permission_user.updated_by_id = 1_234_567_890
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with a string updated_by_id' do
        test_permission_user.updated_by_id = 'testing id'
        expect(test_permission_user).not_to(be_valid)
      end

      it 'is not valid with a negative integer as updated_by_id' do
        test_permission_user.updated_by_id = -12
        expect(test_permission_user).not_to(be_valid)
      end
    end
  end
end
