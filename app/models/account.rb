class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :deposits, class_name: "Transaction::Deposit"
  has_many :withdraws, class_name: "Transaction::Withdraw"
  has_many :transfers, class_name: "Transaction::Transfer"

  validates_presence_of :number, :agency, :token, :limit, :balance, :user
  validates_uniqueness_of :number, :token, case_sensitive: true

  def set_account_attributes
    self.number = generate_number
    self.agency = generate_agency
    self.token = generate_token
    self.limit = generate_limit

    self
  end

  def generate_number
    number = ''
    4.times { number += rand(0..9).to_s }
    number += "-#{rand(0..9)}"
    number
  end

  def generate_agency
    agency = ''
    4.times { agency += rand(0..9).to_s }
    agency
  end

  def generate_token
    SecureRandom.hex
  end

  def generate_limit
    rand(1000.00..1800.00).round(2).to_d
  end

  def update_limit(limit)
    time_diff = ((Time.zone.now - limit_updated_at) / 1.minute).round rescue nil

    if time_diff.nil? || time_diff > 10
      update(limit: limit, limit_updated_at: Time.zone.now)
    else
      try_again_time = (10 - time_diff)
      errors[:base] << "Você atualizou seu limite recentemente, tente novamente em #{try_again_time} minutos."
    end
  end

  def update_balance(value)
    self.balance += value
    save
  end
end
