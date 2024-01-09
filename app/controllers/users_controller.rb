class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  def index 
    @users = User.paginate(page: params[:page])
  end

  # GET /users/:id
  def show
    # @user = User.first
    @user = User.find(params[:id])
    # => app/views/users/show.html.erb
  end

  # => GET users/new or /signup
  def new
    # app/views/users/new.html.erb
    @user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user  # => GET users/:id
      reset_session
      log_in @user
      # redirect_to user_path(@user) => GET users/:id
      # redirect_to user_path(@user.id) GET users/:2
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.html.erb
  end

  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # @users.errors <= ここにデータが入っている
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private
  
    # Strong Parameters
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

    # beforeフィルタ
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end

end
