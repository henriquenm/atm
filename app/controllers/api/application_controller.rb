module Api
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authenticate

    private

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          Account.find_by(token: token)
        end
      end

      def current_account
        @current_account ||= authenticate
      end
  end
end