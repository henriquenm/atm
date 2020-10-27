FactoryBot.define do
  factory :user, class: User do
    full_name { Faker::Name.name }
    cpf { "123.456.789-10" }
    birth_date { "20/02/1986" }
    gender { "male" }
    password { "test123" }
    password_confirmation { "test123" }
    address_attributes { attributes_for(:address) }
  end

  factory :transfer_user, class: User do
    full_name { Faker::Name.name }
    cpf { "241.234.567-54" }
    birth_date { "10/01/1980" }
    gender { "female" }
    password { "test123" }
    password_confirmation { "test123" }
    address_attributes { attributes_for(:address) }
  end

  factory :address, class: Address do
    user
    street { "Rua Teste" }
    number { "19a" }
    district { "Vila Teste" }
    city { "São Paulo" }
    state { "São Paulo" }
    zipcode { "43125432" }
  end

  factory :account, class: Account do
    user
    number { "1234-5" }
    agency { "4321" }
    token { SecureRandom.hex }
    limit { 1400 }
    balance { 150 }
  end

  factory :transfer_account, class: Account do
    user
    number { "5555-5" }
    agency { "0999" }
    token { SecureRandom.hex }
    limit { 1800 }
    balance { 10 }
  end

  factory :account_limit_updated, class: Account do
    user
    number { "1234-5" }
    agency { "4321" }
    token { SecureRandom.hex }
    limit { 1400 }
    balance { 150 }
    limit_updated_at { Time.zone.now }
  end

  factory :deposit_transaction, class: Transaction do
    operation_type { "deposit" }
    operation_nature { "in" }
    value { "160" }
    completed { true }
    created_at { Time.zone.now }
  end

  factory :deposit_transaction_2, class: Transaction do
    operation_type { "deposit" }
    operation_nature { "in" }
    value { "600" }
    completed { true }
    created_at { Time.zone.now }
  end

  factory :withdraw_transaction, class: Transaction do
    operation_type { "withdraw" }
    operation_nature { "out" }
    value { "100" }
    completed { true }
    created_at { Time.zone.now }
  end

  factory :out_transfer_transaction, class: Transaction do
    operation_type { "transfer" }
    operation_nature { "out" }
    value { "90" }
    completed { true }
    created_at { 8.days.ago }
  end

  factory :in_transfer_transaction, class: Transaction do
    operation_type { "transfer" }
    operation_nature { "in" }
    value { "90" }
    completed { true }
    created_at { 8.days.ago }
  end
end
