class Admin::ActivityLogsController < ApplicationController
  def index
    @logs = ActivityLog.order(created_at: :desc).includes(:user)
  end
end
