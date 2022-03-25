module Mutations
    class AddTransaction < Mutations::BaseMutation
        argument :params, Types::Input::TransactionInputType, required: true

        field :transaction, Types::TransactionType, null: false

        def resolve(params:)
            transaction_params = Hash params

            begin
                transaction = Transaction.create!(transaction_params)

                { transaction: transaction }
            rescue ActiveRecord::RecordInvalid => e
                GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
                " #{e.record.errors.full_messages.join(', ')}")
            end
        end
    end
end

<<-DOC

mutation {
  addTransaction(input: { params: { 
    address: "0x01b868b3d2c9ccb62168efd82b8db5e9059ee7fe", 
    txnHash: "0xb64b160ebbc1870328cb4c0d72fe757e1a5145b608505a14241b0235360947dc",
    summary: "GraphQL tutorials",
    from: "John Doe",
    to: "Jane Doe",
    location: "25 East Washington Suite 509 Chicago IL 60602"
  }}) {
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
