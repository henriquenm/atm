require 'rails_helper'

describe 'User creation in POST /api/v1/users', type: :request do
  before do
    post '/api/v1/users', params: { 
      user: {
        full_name: 'João',
        cpf: '123.456.789-10',
        birth_date: '13/06/1975',
        gender: 'male',
        password: 'test123',
        password_confirmation: 'test123',
        address_attributes: {
          street: 'Rua Teste',
          number:'19a',
          district: 'Vila Teste',
          city: 'São Paulo',
          state: 'São Paulo',
          zipcode: '43125432'
        }
      }
    }
  end
  
  it 'returns the account number, agency and token' do
    account = User.first.account
    account_json = {'account':{'agency':"#{account.agency}",'number':"#{account.number}",'token':"#{account.token}"}}.to_json
    expect(JSON.parse(response.body)).to eq(JSON.parse(account_json))
  end

  it 'returns a ok status' do
    expect(response).to have_http_status(:ok)
  end
end

describe 'User fail creation in POST /api/v1/users', type: :request do
  before do
    post '/api/v1/users', params: { 
      user: {
        full_name: 'João',
        cpf: '',
        birth_date: '14/03/1995',
        gender: 'male',
        password: 'test123',
        password_confirmation: 'test12',
        address_attributes: {
          street: 'Rua Filipinas',
          number:'197',
          district: '',
          city: 'Santo André',
          state: 'São Paulo',
          zipcode: '09270420'
        }
      }
    }
  end

  it 'returns an unprocessable entity status' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end