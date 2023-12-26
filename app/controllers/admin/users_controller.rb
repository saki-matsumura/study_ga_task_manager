class Admin::UsersController < ApplicationController
  before_action :exclude_general

  def index
    @users = User.all
  end

  private

  def exclude_general
    redirect_to calendar_tasks_path, notice: "管理者以外はアクセスできません" unless current_user.roll == 'admin'
  end
end
