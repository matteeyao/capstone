# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/index', type: :view do
  before(:each) do
    assign(
      :transactions, 
      [
        Transaction.create!(
          txn_hash: '0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5',
          summary: 'Specify goods/services transacted for here',
          from: 'John Doe',
          to: 'Jane Doe',
          location: '100 W. Lake St. Addison IL 60101 630-628-0358',
          address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
        ),
        Transaction.create!(
          txn_hash: '0x567be1fac6fa34aa0cb273fc2afb6e584bb75b0444784629f252c45ee164f421',
          summary: 'Specify goods/services transacted for here',
          from: 'John Adams',
          to: 'George Washington',
          location: '1600 Pennsylvania Avenue NW Washington, D.C. 20502',
          address: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'
        )
      ])
  end

  it 'renders a list of transactions' do
    render
    assert_select 'tr>td', text: '0x8c469877b27932abdd2313c4b6bf7cff5667fdb9'.to_s, count: 2
    assert_select 'tr>td', text: 'Specify goods/services transacted for here'.to_s, count: 2
    assert_select 'tr>td', text: '0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5'.to_s, count: 1
  end
end
