# ATM by Henrique

## Requirements
  - Ruby 2.7.2
  - Rails 6.0.3
  - Mysql

## Getting started

First of all, you need to clone the project into your local machine and enter in the project's folder.

```bash
git clone git@github.com:henriquenm/atm.git
cd atm
```

Now, run bundler to install all project's gems and dependencies.

```bash
bundle install
```

If necessary run the following command to update your Yarn packages.

```bash
yarn install --check-files
```

Create and configure the 'database.yml' to create database. Example:

```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: atm_development
  username: root
  password: rootpassword
  host: localhost
```

After database configuration file is created, run the following commands to create database and run migrations.

```bash
rake db:create
rake db:migrate
```

And it's done! Run the rails server to test it on http://localhost:3000/

```bash
rails server
```

## API

### Creating user.

```bash
curl -d '{"user": {"full_name":"João","cpf":"123.456.789-10","birth_date":"11/07/1969","gender":0,"password":"test123","password_confirmation":"test123","address_attributes": {"street":"Rua Teste","number":"123","district":"Bairro Teste","city":"Santo André","state":"São Paulo","zipcode":"09270420"}}}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/users
```

When you run the command above, the API will create user, address and the account. And will return the account generated informations.

```bash
{"account_number":"4717-5","account_agency":"6373","account_token":"c49d09e1b3261d36ffa1d494139c1d0c"}
```

To make transactions and get account informations, you will need to use the account_token for authentication.

### Show balance:
```bash
curl -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" http://localhost:3000/api/v1/accounts/show_balance

{"balance":"123.0"} # return
```

### Update Limit:
```bash
curl -d '{"limit_value":500}' -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/accounts/update_limit

{"message":"Limite da conta atualizado com sucesso!","limit":"500.0"} # return
```

If you try to update limit before of 10 minutes that you updated, should return something like this:
```bash
{"errors":["Você atualizou seu limite recentemente, tente novamente em 7 minutos."]}
```

## Transactions
### Transactions Statement:
```bash
curl -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" http://localhost:3000/api/v1/transactions/statement # return all transactions made on last 7 days
curl -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" http://localhost:3000/api/v1/transactions/statement?date=26/10/2020
```

### Deposit
```bash
curl -d '{"value":150}' -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/transactions/deposit

{"message":"Depósito realizado com sucesso!","balance":"150.0"} # return
```

If you try to deposit more than R$ 800 in the same day, you should see:

```bash
{"errors":["Você atingiu o limite diário de R$ 800, tente novamente amanhã."]}
```

### Withdraw

### Transfer
```bash
curl -d '{"account_number":"5371-4","value":150}' -H "Authorization: Token c49d09e1b3261d36ffa1d494139c1d0c" -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/transactions/transfer

{"message":"Transferência realizada com sucesso!"} # return
```

Wrong account number:
```bash
{"errors":["Número da conta não encontrado. Verifique e tente novamente."]}
```

## Running Tests

Run rspec tests by typing
```bash
rspec
```

And see coverage with simplecov
```bash
open coverage/index.html
```