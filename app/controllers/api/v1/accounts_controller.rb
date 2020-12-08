module Api
  module V1
    class AccountsController < Api::ApplicationController
      def show_balance
        if current_account
          render json: { account: { balance: current_account.balance } }
        end
      end

      def show_limit
        if current_account
          render json: { account: { limit: current_account.limit } }
        end
      end

      def update_limit
        if current_account && params[:limit_value].present?
          current_account.update_limit(params[:limit_value])

          if current_account.errors.empty?
            render json: { message: 'Limite da conta atualizado com sucesso!', account: { limit: current_account.limit } }
          else
            render json: { errors: current_account.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: 'Parâmetro limit_value não está presente!' }, status: :unprocessable_entity
        end
      end
    end
  end
end
