module Queries
  class FetchTransaction < Queries::BaseQuery
    
    type Types::TransactionType, null: false
    argument :address, String, required: true
    argument :txn_hash, String, required: true,
    description: "Returns a single transaction metadata entry"

    def resolve(address:, txn_hash:)
      Transaction
        .where(address: address)
        .find_by(txn_hash: txn_hash)
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
    transaction(
        address: "0x8c469877b27932abdd2313c4b6bf7cff5667fdb9", 
        txnHash: "0xb779cc105c9227a0d04a55a414f2eb21ff81030ae9d7daae7153bf46b425a836"
    ) {
        id
        address
        txnHash
        summary
        from
        to
        location
    }
}

query($address: String!, $txnHash: String!) {
    transaction(address: $address, txnHash: $txnHash) {
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
  "address": "0x8c469877b27932abdd2313c4b6bf7cff5667fdb9",
  "txnHash": "0x567be1fac6fa34aa0cb273fc2afb6e584bb75b0444784629f252c45ee164f421"
}

DOC
