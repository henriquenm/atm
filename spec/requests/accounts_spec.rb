require 'rails_helper'

describe 'Show balance account in GET /api/v1/accounts/show_balance', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    get '/api/v1/accounts/show_balance', headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end
  
  it 'returns the account balance' do
    expected_json = {'account':{'balance':"#{account.balance}"}}.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(expected_json))
  end

  it 'returns a ok status' do
    expect(response).to have_http_status(:ok)
  end
end

describe 'Show balance account without token in GET /api/v1/accounts/show_balance', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    get '/api/v1/accounts/show_balance'
  end

  it 'returns a unauthorized status' do
    expect(response).to have_http_status(:unauthorized)
  end
end

describe 'Update account limit in PUT /api/v1/accounts/update_limit', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    put '/api/v1/accounts/update_limit', params: {limit_value: 1700}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end
  
  it 'returns the success message and account limit' do
    account.reload
    expected_json = {'message':'Limite da conta atualizado com sucesso!','account':{'limit':"#{account.limit}"}}.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(expected_json))
  end

  it 'returns a ok status' do
    expect(response).to have_http_status(:ok)
  end
end

describe 'Update account limit that already updated in PUT /api/v1/accounts/update_limit', type: :request do
  let!(:account) { FactoryBot.build(:account_limit_updated) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    put '/api/v1/accounts/update_limit', params: {limit_value: 1700}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'returns an unprocessable entity status' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

describe 'Update account limit that updated in more than 10 minutes in PUT /api/v1/accounts/update_limit', type: :request do
  let!(:account) { FactoryBot.build(:account_limit_updated, limit_updated_at: 11.minutes.ago) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    put '/api/v1/accounts/update_limit', params: {limit_value: 1700}.to_json,
    headers: {"Authorization": "Token #{account.token}", "Content-Type": "application/json"}
  end

  it 'returns the success message and account limit' do
    account.reload
    expected_json = {'message':'Limite da conta atualizado com sucesso!','account':{'limit':"#{account.limit}"}}.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(expected_json))
  end
end

describe 'Update account limit without pass token in PUT /api/v1/accounts/update_limit', type: :request do
  let!(:account) { FactoryBot.build(:account) }
  let!(:user) { FactoryBot.create(:user, account: account) }

  before do
    put '/api/v1/accounts/update_limit', params: {limit_value: '1700'}.to_json
  end
  
  it 'returns the unauthorized error' do
    expect(response).to have_http_status(:unauthorized)
  end
end
