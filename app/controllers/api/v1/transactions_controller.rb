class Api::V1::TransactionsController < Api::ApplicationController

  def statement
    transactions = Transaction.get_statement(current_account, params[:date])

    if transactions
      render json: {transactions: transactions}
    end
  end

  def deposit
    transaction = Transaction.deposit(current_account, params[:value])

    unless transaction.errors.any?
      render json: {message: "Depósito realizado com sucesso!", balance: current_account.balance}
    else
      render json: {errors: transaction.errors.full_messages}
    end
  end

  # TODO
  # def withdraw
  #   if params[:transaction_id]
  #     transaction = Transaction.withdraw(current_account, params[:transaction_id], params[:value])

  #     if transaction
  #       render json: {message: "Saque realizado com sucesso!", balance: current_account.balance}
  #     else
  #       render json: {errors: "Transação não encontrada!"}
  #     end
  #   else
  #     transaction = Transaction.pre_withdraw(current_account, params[:value])
  #     # ????
  #   end
  # end

  def transfer
    transaction = Transaction.transfer(current_account, params[:account_number], params[:value])

    unless transaction.errors.any?
      render json: {message: "Transferência realizada com sucesso!"}
    else
      render json: {errors: transaction.errors.full_messages}
    end
  end
end
