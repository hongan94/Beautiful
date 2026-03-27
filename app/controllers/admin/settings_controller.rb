class Admin::SettingsController < ApplicationController
  def index
    @settings = Setting.all
  end

  def create
    # Mass update settings from form
    if params[:settings].present?
      params[:settings].each do |key, value|
        Setting.set(key, value)
      end
    end
    redirect_to admin_settings_path, notice: "Settings updated successfully"
  end
end
