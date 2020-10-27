class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates_presence_of :number, :agency, :token, :limit, :balance, :user
  validates_uniqueness_of :number, :token

  def set_account_attributes
    self.number = generate_number
    self.agency = generate_agency
    self.token = generate_token
    self.limit = generate_limit
  end

  def generate_number
    number = ""
    4.times{ number += rand(0..9).to_s }
    number += "-#{rand(0..9).to_s}"
    number
  end

  def generate_agency
    agency = ""
    4.times{ agency += rand(0..9).to_s }
    agency
  end

  def generate_token
    SecureRandom.hex
  end

  def generate_limit
    rand(1000.00..1800.00).round(2).to_d
  end

  def update_limit(limit)
    if self.limit_updated_at.nil?
      self.update(limit: limit, limit_updated_at: DateTime.now)
    else
      time_diff = ((Time.now - self.limit_updated_at) / 1.minute).round
      try_again_time = 10 - time_diff

      if time_diff > 10
        self.update(limit: limit, limit_updated_at: DateTime.now)
      else
        self.errors[:base] << "Você atualizou seu limite recentemente, tente novamente em #{try_again_time} minutos."
      end
    end
  end

  def update_balance(value)
    self.balance += value
    self.save
  end
end
