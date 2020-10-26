class Api::V1::AccountsController < Api::ApplicationController

  def show_balance
    if current_account
      render json: {balance: current_account.balance}
    end
  end

  def update_limit
    if current_account
      current_account.update_limit(params[:limit_value])

      unless current_account.errors.any?
        render json: {message: "Limite da conta atualizado com sucesso!", limit: current_account.limit}
      else
        render json: {errors: current_account.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end
end
