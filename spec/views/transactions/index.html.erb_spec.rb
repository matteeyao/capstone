# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/index', type: :view do
  before(:each) do
    assign(:transactions, [
             Transaction.create!(
               title: 'Title',
               body: 'MyText',
               published: false
             ),
             Transaction.create!(
               title: 'Title',
               body: 'MyText',
               published: false
             )
           ])
  end

  it 'renders a list of transactions' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
