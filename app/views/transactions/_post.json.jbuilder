# frozen_string_literal: true

json.extract! transaction, :id, :title, :body, :published, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
