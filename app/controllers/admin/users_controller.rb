class Admin::UsersController < ApplicationController
  include JsonIndexable
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_status]

  def index
    respond_to do |format|
      format.html
      format.json do
        handle_json_index(controller_name.classify, UserBlueprint) { |model| model.user }
      end
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end


  def update_status
    status = params[:status]

    if User.statuses.key?(status)
      if @user.update(status: status)
        render json: { success: true, status: @user.status }
      else
        render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "Invalid status" }, status: :bad_request
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :first_name, :last_name, :phone_number, :gender, :address, :status, :avatar_url)
  end
end
