module Mutations
    class UpdateTransaction < BaseMutation
        argument :address, String, required: true
        argument :txn_hash, String, required: true
        argument :params, Types::Input::TransactionInputType, required: true

        field :transaction, Types::TransactionType, null: false

        def resolve(address:, txn_hash:, params:)
            transaction_params = Hash params

            begin
                transaction = Transaction
                    .where(address: address)
                    .find_by(txn_hash: txn_hash)
                    
                transaction.update(transaction_params)

                { transaction: transaction }
                
            rescue ActiveRecord::RecordNotFound => e
                GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
                " #{e.record.errors.full_messages.join(', ')}")
            end
        end
    end
end

<<-DOC

mutation {
  updateTransaction(
    input: {
      address: "0x01b868b3d2c9ccb62168efd82b8db5e9059ee7fe",
    	txnHash: "0xb64b160ebbc1870328cb4c0d72fe757e1a5145b608505a14241b0235360947dc",
      params: { 
        address: "0x01b868b3d2c9ccb62168efd82b8db5e9059ee7fe", 
        txnHash: "0xb64b160ebbc1870328cb4c0d72fe757e1a5145b608505a14241b0235360947dc",
        summary: "GraphQL mutation tutorials",
        from: "John Doe",
        to: "Jane Doe",
        location: "Mountain View, CA"
      }
    }
  ) {
    transaction {
      id
      address
      txnHash
      summary
      from
      to
      location
    }
  }
}

DOC
