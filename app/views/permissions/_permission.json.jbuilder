# frozen_string_literal: true

json.extract!(permission, :id, :description, :created_at, :updated_at)
json.url(permission_url(permission, format: :json))
