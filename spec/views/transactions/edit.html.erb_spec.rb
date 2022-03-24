# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/edit', type: :view do
  before(:each) do
    @transaction = assign(
      :transaction,
      Transaction.create!(
        txn_hash: '0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5',
        summary: 'Specify goods/services transacted for here',
        from: 'John Doe',
        to: 'Jane Doe',
        location: '100 W. Lake St. Addison IL 60101 630-628-0358',
        address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
      ))
  end

  it 'renders the edit transaction form' do
    render

    assert_select 'form[action=?][method=?]', transaction_path(@transaction), 'post' do
      assert_select 'input[name=?]', 'transaction[address]'

      assert_select 'input[name=?]', 'transaction[txn_hash]'

      assert_select 'input[name=?]', 'transaction[from]'

      assert_select 'input[name=?]', 'transaction[to]'

      assert_select 'textarea[name=?]', 'transaction[summary]'

      assert_select 'textarea[name=?]', 'transaction[location]'
    end
  end
end
