module Api
  module V1
    class AuthController < ActionController::API
      # API login using JWT
      def login
        user = User.find_by(email_address: params[:email])

        if user&.authenticate(params[:password])
          # Generate JWT token
          token = JsonWebToken.encode(user_id: user.id)
          time = Time.now + 24.hours.to_i
          render json: { 
            token: token, 
            exp: time.strftime("%m-%d-%Y %H:%M"),
            user: {
              id: user.id,
              name: user.name,
              email: user.email_address,
              role: user.role
            }
          }, status: :ok
        else
          render json: { error: 'Unauthorized: Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
