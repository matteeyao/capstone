# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # This should return the minimal set of attributes required to create a valid
  # Transaction. As you add validations to Transaction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      txn_hash: '0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5',
      summary: 'Specify goods/services transacted for here',
      from: 'John Doe',
      to: 'Jane Doe',
      location: '100 W. Lake St. Addison IL 60101 630-628-0358',
      address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
    }
  end

  let(:invalid_attributes) do
    {
      txn_hash: nil,
      summary: nil,
      from: nil,
      to: nil,
      location: nil,
      address: nil
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
