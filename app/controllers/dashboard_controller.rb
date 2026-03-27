class DashboardController < ApplicationController
  before_action :authorize_request

  def index
    user = CacheService.fetch("users_cache") do
      CircuitBreakerService.call("http://localhost:3001/users")
    end

    orders = CacheService.fetch("orders_cache") do
      CircuitBreakerService.call("http://localhost:3002/orders")
    end

    render json: { user: user, orders: orders }
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JsonWebToken.decode(token)

    unless decoded && decoded["role"] == "admin"
      render json: { error: "Forbidden" }, status: 403
    end
  end
end