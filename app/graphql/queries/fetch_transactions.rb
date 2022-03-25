module Queries
  class FetchTransactions < Queries::BaseQuery

    type [Types::TransactionType], null: false
    argument :address, String, required: true,
    description: "Returns a list of transaction metadata entries"

    def resolve(address:)
      Transaction.where(address: address)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Transaction does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end
  end
end

<<-DOC

QUERIES:

{
  transactions(address: "0x43085ac677366bd8c114df35a41bf8266aa2142a") {
    id
    address
    txnHash
    summary
    from
    to
    location
  }
}

query($address: String!) {
  transactions(address: $address) {
    id
    address
    txnHash
    summary
    from
    to
    location
  }
}

QUERY VARIABLES:

{
  "address": "0x43085ac677366bd8c114df35a41bf8266aa2142a"
}

DOC
