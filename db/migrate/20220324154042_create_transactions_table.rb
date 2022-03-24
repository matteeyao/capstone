class CreateTransactionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions_tables do |t|
      t.string :txn_hash
      t.text :summary
      t.string :from
      t.string :to
      t.string :location
      t.string :address
    end
  end
end
