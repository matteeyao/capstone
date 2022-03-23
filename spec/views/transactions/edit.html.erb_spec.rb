# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/edit', type: :view do
  before(:each) do
    @transaction = assign(
      :transaction,
      Transaction.create!(
        title: 'MyString',
        body: 'MyText',
        published: false
      ))
  end

  it 'renders the edit transaction form' do
    render

    assert_select 'form[action=?][method=?]', transaction_path(@transaction), 'post' do
      assert_select 'input[name=?]', 'transaction[title]'

      assert_select 'textarea[name=?]', 'transaction[body]'

      assert_select 'input[name=?]', 'transaction[published]'
    end
  end
end
