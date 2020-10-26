class Api::V1::UsersController < ActionController::API

  def create
    user = User.new(user_params.except(user_params[:address_attributes]))
    user.build_address(user_params[:address_attributes])
    account = user.build_account
    account.set_account_attributes

    if user.save
      render json: {account_number: account.number, account_agency: account.agency, account_token: account.token}
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:full_name, :cpf, :birth_date, :gender, :password, :password_confirmation,
        address_attributes: [:street, :number, :district, :complement, :city, :state, :zipcode])
    end
end
