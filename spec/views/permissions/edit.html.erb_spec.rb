# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('permissions/edit', type: :view) do
    before do
        @permission = assign(:permission, Permission.create!(
                                              description: 'MyString'
                                          )
        )
    end

    it 'renders the edit permission form' do
        render

        assert_select 'form[action=?][method=?]', permission_path(permission), 'post' do
            assert_select 'input[name=?]', 'permission[description]'
        end
    end
end
