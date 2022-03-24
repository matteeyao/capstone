# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates_presence_of :txn_hash
  validates_presence_of :address
end
