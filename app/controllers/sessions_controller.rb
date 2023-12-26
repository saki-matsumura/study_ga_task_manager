class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create, :guest_sign_in, :guest_admin_sign_in]
  def new  
    return redirect_to tasks_path if logged_in?
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン成功
      session[:user_id] = user.id
      redirect_to calendar_tasks_path
    else
      # ログイン失敗
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

  def guest_sign_in
    user = User.guest
    session[:user_id] = user.id
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  def guest_admin_sign_in
    user = User.guest_admin
    session[:user_id] = user.id
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

end
