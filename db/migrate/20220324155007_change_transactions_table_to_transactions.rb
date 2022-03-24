class ChangeTransactionsTableToTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_table :transactions_tables, :transactions
  end
end
