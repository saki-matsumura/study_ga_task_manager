class Admin::UsersController < ApplicationController
  before_action :exclude_general

  def index
    @users = User.all
  end

  private

  def exclude_general
    unless current_user.roll == 'admin'
      # msg；管理者以外はアクセスできません
      flash[:danger] = t('danger.only_administrators')
      redirect_to calendar_tasks_path
    end
  end
end
