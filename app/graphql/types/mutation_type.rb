module Types
  class MutationType < Types::BaseObject
    field :add_transaction, mutation: Mutations::AddTransaction
    field :update_transaction, mutation: Mutations::UpdateTransaction
  end
end
