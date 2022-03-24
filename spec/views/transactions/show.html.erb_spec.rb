# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/show', type: :view do
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

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/0x8c469877b27932abdd2313c4b6bf7cff5667fdb9/)
    expect(rendered).to match(/0x0c3a287ce8b9617dbb2b5b7299076dde7a43edde6f19709c0becd046856076e5/)
    expect(rendered).to match(/^[a-zA-Z0-9_ ]*$/)
    expect(rendered).to match(/^[a-zA-Z0-9_ ]*$/)
    expect(rendered).to match(/^[a-zA-Z0-9_ ]*$/)
    expect(rendered).to match(/^[a-zA-Z0-9_ ]*$/)
  end
end
