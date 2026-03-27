class Admin::UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:edit, :update, :destroy]

  def index
    @user_groups = UserGroup.all
  end

  def new
    @user_group = UserGroup.new
    @permissions = Permission.all.group_by(&:subject_class)
  end

  def create
    @user_group = UserGroup.new(user_group_params)
    if @user_group.save
      redirect_to admin_user_groups_path, notice: "Group was successfully created."
    else
      @permissions = Permission.all.group_by(&:subject_class)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @permissions = Permission.all.group_by(&:subject_class)
  end

  def update
    if @user_group.update(user_group_params)
      redirect_to admin_user_groups_path, notice: "Group was successfully updated."
    else
      @permissions = Permission.all.group_by(&:subject_class)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_group.destroy
    redirect_to admin_user_groups_path, notice: "Group was successfully deleted."
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def user_group_params
    params.require(:user_group).permit(:name, :description, permission_ids: [])
  end
end
