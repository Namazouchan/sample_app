class SessionsController < ApplicationController
  def new
    # x @session = Session.new
    # o scope: :session + url: login_path
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      reset_session      # ログインの直前に必ずこれを書くこと
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' 
      render 'new', status: :unprocessable_entity
      # redirect_to と　renderの違い
      # redirect_to GET /users/1 => show template
      #                             reder 'new'(0回目) 
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
