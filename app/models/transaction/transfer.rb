class Transaction::Transfer < Transaction

  def self.make_transfer(account, target_account_number, value)
    target_account = Account.find_by(number: target_account_number)

    if target_account
      out_transaction = self.create(account: account, operation_nature: 'out', value: value)
      account.update_balance(-value)

      in_transaction = self.create(account: target_account, operation_nature: 'in', value: value)
      target_account.update_balance(value)
    else
      out_transaction = self.new(account: account, operation_nature: "out", value: value)
      out_transaction.errors[:base] << 'Número da conta não encontrado. Verifique e tente novamente.'
    end

    out_transaction
  end
end