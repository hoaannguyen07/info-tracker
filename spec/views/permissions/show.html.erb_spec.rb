# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('permissions/show', type: :view) do
    before do
        @permission = assign(:permission, Permission.create!(
                                              description: 'Description'
                                          )
        )
    end

    it 'renders attributes in <p>' do
        render
        expect(rendered).to(match(/Description/))
    end
end
