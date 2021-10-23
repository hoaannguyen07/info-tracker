# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('permissions/new', type: :view) do
    before do
        assign(:permission, Permission.new(
                                description: 'MyString'
                            )
        )
    end

    it 'renders new permission form' do
        render

        assert_select 'form[action=?][method=?]', permissions_path, 'post' do
            assert_select 'input[name=?]', 'permission[description]'
        end
    end
end
