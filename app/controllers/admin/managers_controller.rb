class Admin::ManagersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
  
    def index
      @pagy, @managers = pagy(Manager.includes(avatar_url_attachment: :blob).all)
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
  
      if @manager.save
        redirect_to admin_managers_path, notice: 'Manager was successfully created.'
      else
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
      redirect_to admin_managers_path, notice: 'Manager was successfully deleted.'
    end
  
    private
  
    def set_manager
      @manager = Manager.find(params[:id])
    end
  
    def manager_params
      params.require(:manager).permit(:email, :password, :password_confirmation)
    end
  end
  