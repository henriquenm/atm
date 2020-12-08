class Transaction < ApplicationRecord
  belongs_to :account

  validates_presence_of :type, :operation_nature, :value, :account

  enum operation_nature: [ :in, :out ]

  def self.get_statement(account, date)
    date = date ? date.to_date : 7.days.ago
    account.transactions.where('created_at >= ?', date)
  end
end
