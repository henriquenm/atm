require 'rails_helper'

describe 'Get transactions statements in GET /api/v1/transactions/statement', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }
  let!(:deposit_transaction) { FactoryBot.create(:deposit_transaction, account: account) }
  let!(:withdraw_transaction) { FactoryBot.create(:withdraw_transaction, account: account) }
  let!(:out_transfer_transaction) { FactoryBot.create(:out_transfer_transaction, account: account) }

  before do
    get '/api/v1/transactions/statement', headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'return all transactions made on last 7 days' do
    expected_json = {'transactions':[deposit_transaction, withdraw_transaction]}.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(expected_json))
  end
end

describe 'Create successfull deposit transactions in PUT /api/v1/transactions/deposit', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    put '/api/v1/transactions/deposit', params: {value: 500}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'return message and account balance' do
    account.reload
    expected_json = {'message':'Depósito realizado com sucesso!','balance':"#{account.balance}" }.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(expected_json))
  end
end

describe 'Create fail deposit transactions in PUT /api/v1/transactions/deposit', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }
  let!(:deposit_transaction) { FactoryBot.create(:deposit_transaction, account: account) }
  let!(:deposit_transaction_2) { FactoryBot.create(:deposit_transaction_2, account: account) }

  before do
    put '/api/v1/transactions/deposit', params: {value: 100}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'return error message and account balance' do
    account.reload
    expect(JSON.parse(response.body)["errors"][0]).to eq("Você atingiu o limite diário de R$ 800, tente novamente amanhã.")
  end
end

describe 'Create successfull transfer transactions in PUT /api/v1/transactions/transfer', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }
  let!(:transfer_account) { FactoryBot.build(:transfer_account) }
  let!(:transfer_user) { FactoryBot.create(:transfer_user, account: transfer_account) }

  before do
    put '/api/v1/transactions/transfer', params: {value: 500, account_number: transfer_account.number}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'return transfer successfull message' do
    account.reload
    expect(JSON.parse(response.body)["message"]).to eq("Transferência realizada com sucesso!")
  end
end

describe 'Create transfer transactions without account number in PUT /api/v1/transactions/transfer', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }
  let!(:transfer_account) { FactoryBot.build(:transfer_account) }
  let!(:transfer_user) { FactoryBot.create(:transfer_user, account: transfer_account) }

  before do
    put '/api/v1/transactions/transfer', params: {value: 500}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'return transfer account number not found message' do
    account.reload
    expect(JSON.parse(response.body)["errors"][0]).to eq("Número da conta não encontrado. Verifique e tente novamente.")
  end
end