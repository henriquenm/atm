class Transaction::Withdraw < Transaction

  def self.make_withdraw(account, transaction_id)
    transaction = self.find(transaction_id) rescue nil

    if transaction
      transaction.save
      account.update_balance(-transaction.value)
    end

    transaction
  end

  def self.pre_withdraw(account, value)
    transaction = self.create(account: account, operation_nature: "out", value: value)
    available_notes = [100, 50, 20, 10, 5, 2]
    notes = calculate_money_notes(value, available_notes)
    notes = notes.delete_if { |k, v| v == 0 }

    [transaction, notes]
  end

  def self.calculate_money_notes(value, available)
    note, *rest = available
    if rest.empty?
      return { note => 0 } if value.zero?
      return nil if (value % note) > 0
      return { note => value/note }
    end
    last = nil
    amount = [value/note].min.downto(0).find { |amount| last = calculate_money_notes(value-amount*note, rest) }
    amount.nil? ? nil : { note => amount }.merge(last)
  end
end