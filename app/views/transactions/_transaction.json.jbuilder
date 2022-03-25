# frozen_string_literal: true

json.extract! transaction, :id, :txn_hash, :summary, :from, :to, :location, :address
json.url transaction_url(transaction, format: :json)
