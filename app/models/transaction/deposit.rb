class Transaction::Deposit < Transaction

  DEPOSIT_TOTAL = 800

  def self.make_deposit(account, value)
    deposit_total = calculate_deposit_total(account, value)
    deposit_transaction = self.new(account: account, operation_nature: "in", value: value)

    unless deposit_total > DEPOSIT_TOTAL
      deposit_transaction.save
      account.update_balance(value)
    else
      deposit_transaction.errors[:base] << "O valor do depósito excede o limite diário de R$ #{DEPOSIT_TOTAL}."
    end

    deposit_transaction
  end

  def self.calculate_deposit_total(account, value)
    deposits = account.deposits.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    if deposits.present?
      deposit_total = deposits.pluck(:value).inject { |sum, x| sum + x }
      deposit_total + value
    else
      value
    end
  end
end