# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('permissions/index', type: :view) do
    before do
        assign(:permissions, [
            Permission.create!(
                description: 'Description'
            ),
            Permission.create!(
                description: 'Description'
            )
        ]
        )
    end

    it 'renders a list of permissions' do
        render
        assert_select 'tr>td', text: 'Description'.to_s, count: 2
    end
end
