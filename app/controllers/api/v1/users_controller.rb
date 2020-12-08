module Api
  module V1
    class UsersController < ActionController::API
      def create
        user = User.new(user_params)
        account = user.build_account.set_account_attributes

        if user.save
          render json: { account: { number: account.number, agency: account.agency, token: account.token} }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:full_name, :cpf, :birth_date, :gender, :password, :password_confirmation,
          address_attributes: [:street, :number, :district, :complement, :city, :state, :zipcode])
      end
    end
  end
end
