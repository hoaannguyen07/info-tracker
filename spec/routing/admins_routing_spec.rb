# frozen_string_literal: true

# in spec/routing
require 'rails_helper'

RSpec.describe('SessionsController', type: :routing) do
    describe 'routing' do
        it 'routes to #new' do
            expect(get: 'admins/sign_in').to(route_to('admins/sessions#new'))
        end

        it 'routes to #destroy' do
            expect(get: 'admins/sign_out').to(route_to('admins/sessions#destroy'))
        end
    end
end
