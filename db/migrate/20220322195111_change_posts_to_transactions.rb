class ChangePostsToTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_table :posts, :transactions
  end
end
