class Address < ApplicationRecord
    validates_presence_of :transaction
    has_many :transactions, dependent: :destroy
end
