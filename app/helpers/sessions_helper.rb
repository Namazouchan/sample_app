module  SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    # DB への問い合わせの数を可能な限り小さくしたい
    if session[:user_id]
      # User.find_by(id: session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
      # @user = @user || User.find ||はor orは手前がtureの場合は実行しない nilかfalseの場合後が事項される
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil   # 安全のため
  end
    
end
