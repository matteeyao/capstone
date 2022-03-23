# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transactions/show', type: :view do
  before(:each) do
    @transaction = assign(
      :transaction,
      Transaction.create!(
        title: 'Title',
        body: 'MyText',
        published: false
      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
