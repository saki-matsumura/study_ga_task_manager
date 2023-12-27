class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :back_to_index, only: [:show, :edit, :update]

  def new
    return redirect_to calendar_tasks_path if logged_in?
    @user = User.new
    @submit_text = "アカウント登録"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id   # ユーザー作成時にログイン
      redirect_to calendar_tasks_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @submit_text = "保存"
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "ユーザー情報を編集しました！"
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :icon,
                                 :password_confirmation, :roll)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def back_to_index
    redirect_to tasks_path unless current_user == @user
  end

end
