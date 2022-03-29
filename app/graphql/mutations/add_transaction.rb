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

mutation AddTransactionMetadata($address: String) {
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

MUTATION:

mutation AddTransactionMetadata(
  $address: String!, 
  $txnHash: String!, 
  $summary: String,
  $from: String,
  $to: String,
  $location: String,
) {
  addTransaction(input: { params: { 
    address: $address, 
    txnHash: $txnHash,
    summary: $summary,
    from: $from,
    to: $to,
    location: $location
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

QUERY VARIABLES:

{
  "address": "0x8c469877b27932abdd2313c4b6bf7cff5667fdb9",
  "txnHash": "0xeed97c10473725c4350da1dd3441db316e9ca1d2c5e06c68989be89b5bb8017c",
  "summary": "GraphQL tutorials",
  "from": "John Doe",
  "to": "Jane Doe",
  "location": "25 East Washington Suite 509 Chicago IL 60602"
}

DOC
