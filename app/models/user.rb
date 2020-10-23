class User < ApplicationRecord
  has_secure_password

  has_one :address, dependent: :destroy
  has_one :account, dependent: :destroy

  validates_presence_of :full_name, :cpf, :birth_date, :gender, :password_digest

  enum gender: { male: 0, female: 1, other: 2 }
end
