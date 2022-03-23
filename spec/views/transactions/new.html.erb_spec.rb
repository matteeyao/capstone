# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/new', type: :view do
  before(:each) do
    assign(
      :transaction,
      Transaction.new(
        title: 'MyString',
        body: 'MyText',
        published: false
      ))
  end

  it 'renders new transaction form' do
    render

    assert_select 'form[action=?][method=?]', transactions_path, 'post' do
      assert_select 'input[name=?]', 'transaction[title]'

      assert_select 'textarea[name=?]', 'transaction[body]'

      assert_select 'input[name=?]', 'transaction[published]'
    end
  end
end
