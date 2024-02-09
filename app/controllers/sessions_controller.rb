class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create, :guest_sign_in, :guest_admin_sign_in]
  def new  
    return redirect_to tasks_path if logged_in?
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # mes：ログインしました
      session[:user_id] = user.id
      redirect_to calendar_tasks_path, notice: t('notice.sign_in')
    else
      # msg：メールアドレスかパスワードが間違っています（ログイン失敗）
      flash.now[:danger] = t('danger.sign_in_failed')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    # msg：ログアウトしました
    redirect_to new_session_path, notice: t('notice.sign_out')
  end

  def guest_sign_in
    user = User.guest
    session[:user_id] = user.id
    # msg：ゲストユーザーとしてログインしました
    redirect_to root_path, notice: t('notice.gest_user_sign_in')
  end

  def guest_admin_sign_in
    user = User.guest_admin
    session[:user_id] = user.id
    # msg：ゲストユーザー（管理者）としてログインしました
    redirect_to root_path, notice: t('notice.gest_admin_user_sig_in')
  end

end
