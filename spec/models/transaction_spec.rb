# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # This should return the minimal set of attributes required to create a valid
  # Transaction. As you add validations to Transaction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'A new ledger transaction',
      body: 'The body of the transaction'
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      body: nil
    }
  end

  describe 'an valid transaction' do
    it {
      transaction = Transaction.new valid_attributes
      expect(transaction.valid?).to be_truthy
      expect { transaction.save }.to change { Transaction.count }.by(1)
    }
  end

  describe 'an invalid transaction' do
    it {
      transaction = Transaction.new invalid_attributes
      expect(transaction.valid?).to be_falsey
    }
  end
end
