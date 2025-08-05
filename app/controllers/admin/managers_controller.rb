class Admin::ManagersController < ApplicationController
  include JsonIndexable
  before_action :set_manager, only: [:show, :edit, :update, :destroy, :update_status]

  def index
    respond_to do |format|
      format.html
      format.json do
        handle_json_index(controller_name.classify, ManagerBlueprint) { |model| model.admin }
      end
    end
  end

  def show
  end

  def new
    @manager = Manager.new
  end

  def edit
  end

  def create
    @manager = Manager.new(manager_params)

    begin
      if @manager.save
        redirect_to admin_managers_path, notice: 'Manager was successfully created.'
      else
        render :new
      end
    rescue ActiveRecord::RecordNotUnique => e
      @manager.errors.add(:email_address, "has already been taken")
      render :new
    end
  end

  def update
    if @manager.update(manager_params)
      redirect_to admin_managers_path, notice: 'Manager was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @manager.destroy
    respond_to do |format|
      format.html { redirect_to admin_managers_path, notice: 'Manager was successfully deleted.' }
      format.json { render json: { message: 'Manager was successfully deleted.' }, status: :ok }
    end
  end

  def update_status
    status = params[:status]

    if Manager.statuses.key?(status)
      if @manager.update(status: status)
        render json: { success: true, status: @manager.status }
      else
        render json: { success: false, errors: @manager.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "Invalid status" }, status: :bad_request
    end
  end

  private

  def set_manager
    @manager = Manager.find(params[:id])
  end

  def manager_params
    params.require(:manager).permit(:email_address, :password, :password_confirmation, :first_name, :last_name, :phone_number, :gender, :address, :status, :avatar_url)
  end
end
