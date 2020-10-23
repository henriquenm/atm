class Transaction < ApplicationRecord
  belongs_to :account

  validates_presence_of :operation_type, :operation_nature, :value, :account_id

  enum operation_type: { deposit: 0, withdraw: 1, transfer: 2 }
  enum operation_nature: { in: 0, out: 1 }
end
