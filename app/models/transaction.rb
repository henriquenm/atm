class Transaction < ApplicationRecord
  belongs_to :account

  validates_presence_of :operation_type, :operation_nature, :value, :account

  enum operation_type: { deposit: 0, withdraw: 1, transfer: 2 }
  enum operation_nature: { in: 0, out: 1 }

  scope :completed, -> { where(completed: true) }
  scope :deposits, -> { where(operation_type: 0) }

  def self.get_statement(account, date)
    date = date ? date.to_date : 7.days.ago
    account.transactions.completed.where('created_at >= ?', date)
  end

  def self.deposit(account, value)
    deposit_total = calculate_deposit_total(account, value)
    transaction = Transaction.new(account: account, operation_type: 0, operation_nature: 0, value: value)

    unless deposit_total > 800
      transaction.completed = true
      transaction.save

      account.update_balance(value)
    else
      transaction.save
      transaction.errors[:base] << 'Você atingiu o limite diário de R$ 800, tente novamente amanhã.'
    end

    transaction
  end

  # def self.withdraw(account, transaction_id, value)
  #   transaction = Transaction.find(transaction_id)

  #   if transaction
  #     transaction.completed = true
  #     transaction.save

  #     account.update_balance(-value)
  #   end

  #   transaction
  # end

  # TODO
  # def self.pre_withdraw(account, value)
  #   transaction = Transaction.create(account: account, operation_type: 1, operation_nature: 1, value: value, completed: false)
  #   available_notes = [100, 50, 20, 10, 5, 2]
  #   notes = calculate_money_notes(value, available_notes)
  #   notes.delete_if { |k, v| v == 0 }
  # end

  def self.transfer(account, target_account_number, value)
    target_account = Account.find_by(number: target_account_number)

    if target_account
      out_transaction = Transaction.create(account: account, operation_type: 'transfer', operation_nature: 'out', value: value, completed: true)
      account.update_balance(-value)

      Transaction.create(account: target_account, operation_type: 'transfer', operation_nature: 'in', value: value, completed: true)
      target_account.update_balance(value)
    else
      out_transaction = Transaction.create(account: account, operation_type: 2, operation_nature: 1, value: value)
      out_transaction.errors[:base] << 'Número da conta não encontrado. Verifique e tente novamente.'
    end

    out_transaction
  end

  def self.calculate_deposit_total(account, value)
    transactions = account.transactions.completed.deposits.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    if transactions.present?
      deposit_total = transactions.pluck(:value).inject { |sum, x| sum + x }
      deposit_total + value
    else
      value
    end
  end

  # TODO
  # def self.calculate_money_notes(value, available)
  #   note, *rest = available
  #   if rest.empty?
  #     return { note => 0 } if value.zero?
  #     return nil if (value % note) > 0
  #     return { note => value/note }
  #   end
  #   last = nil
  #   amount = [value/note].min.downto(0).find { |amount| last = calculate_money_notes(value-amount*note, rest) }
  #   amount.nil? ? nil : { note => amount }.merge(last)
  # end
end
