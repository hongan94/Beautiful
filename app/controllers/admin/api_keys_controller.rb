class Admin::ApiKeysController < ApplicationController
  def index
    @api_keys = ApiKey.all.order(created_at: :desc)
  end

  def new
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(api_key_params)
    @api_key.user = Current.user
    if @api_key.save
      redirect_to admin_api_keys_path, notice: "API Key created successfully. Token: #{@api_key.token}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])
  end

  def update
    @api_key = ApiKey.find(params[:id])
    if @api_key.update(api_key_params)
      redirect_to admin_api_keys_path, notice: "API Key updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy
    redirect_to admin_api_keys_path, notice: "API Key deleted."
  end

  private

  def api_key_params
    params.require(:api_key).permit(:name, :status, :expires_at)
  end
end
