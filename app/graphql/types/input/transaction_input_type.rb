module Types
  module Input
    class TransactionInputType < Types::BaseInputObject
      argument :address, String, required: true
      argument :txn_hash, String, required: true
      argument :summary, String, required: false
      argument :from, String, required: false
      argument :to, String, required: false
      argument :location, String, required: false
    end
  end
end
