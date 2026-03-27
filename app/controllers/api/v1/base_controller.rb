module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate_api_key!

      private

      def authenticate_api_key!
        authenticate_or_request_with_http_token do |token, _options|
          api_key = ApiKey.find_by_token(token)
          
          if api_key&.usable?
            @current_api_key = api_key
            @current_user = api_key.user
            true
          else
            render json: { error: 'Unauthorized or expired API Key' }, status: :unauthorized
            false
          end
        end
      end

      def current_user
        @current_user
      end
    end
  end
end
