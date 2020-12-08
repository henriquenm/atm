module Api
  module V1
    class TransactionsController < Api::ApplicationController
      def statement
        transactions = Transaction.get_statement(current_account, params[:date])

        if transactions.present?
          render json: { transactions: transactions }, status: :ok
        else
          render json: { message: 'Nenhuma transação encontrada!' }, status: :not_found
        end
      end

      def deposit
        transaction = Transaction::Deposit.make_deposit(current_account, params[:value])

        if transaction.errors.empty?
          render json: { message: 'Depósito realizado com sucesso!', account: { balance: current_account.balance } }, status: :ok
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def withdraw
        if params[:transaction_id]
          transaction = Transaction::Withdraw.make_withdraw(current_account, params[:transaction_id])

          if transaction
            render json: { message: 'Saque realizado com sucesso!', balance: current_account.balance }, status: :ok
          else
            render json: { errors: 'Transação não encontrada!' }, status: :not_found
          end
        else
          transaction, notes = Transaction::Withdraw.pre_withdraw(current_account, params[:value])

          if transaction && notes
            render json: { transaction_id: transaction.id, available_notes: notes }, status: :ok
          end
        end
      end

      def transfer
        transaction = Transaction::Transfer.make_transfer(current_account, params[:account_number], params[:value])

        if transaction.errors.empty?
          render json: { message: 'Transferência realizada com sucesso!' }, status: :ok
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
