class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates_presence_of :number, :agency, :token, :limit, :balance, :user_id
end
