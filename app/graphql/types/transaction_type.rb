# frozen_string_literal: true

module Types
  class TransactionType < Types::BaseObject
    field :id, ID, null: false
    field :txn_hash, String, null: false
    field :summary, String, null: true
    field :from, String, null: true
    field :to, String, null: true
    field :location, String, null: true
    field :address, String, null: false
  end
end
