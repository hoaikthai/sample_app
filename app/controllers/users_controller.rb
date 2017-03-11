class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy
  before_action :get_user, only: :password_create

	def index
		@users = User.paginate(page: params[:page])
	end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile updated"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  def destroy
  	User.find(params[:id]).destroy
  	flash[:succes] = "User deleted"
  	redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def login_with_facebook
    @user = User.koala(request.env['omniauth.auth']['credentials'])
    user = User.find_by(email: @user['email'])
    if user
      log_in user
      if !user.activated
        user.update_attribute(:activated, true)
        user.update_attribute(:activated_at, Time.zone.now)
      end
      redirect_to user
    else
      @user = User.create(name: @user['name'],
                         email: @user['email'],
                         password: "foobar",
                         password_confirmation: "foobar")
      render 'create_password'
    end
  end

  def login_with_google
    @user = User.from_omniauth(request.env['omniauth.auth'])
    user = User.find_by(email: @user.email)
    if user.activated?
      log_in user
      redirect_to user
    else
      render 'create_password'
    end
  end

  def password_create
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'create_password'
    elsif @user.update_attributes(password_params)
      log_in @user
      @user.update_attribute(:activated, true)
      @user.update_attribute(:activated_at, Time.zone.now)
      flash[:success] = "Password has been created"
      redirect_to @user
    else
      render 'create_password'
    end
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to root_url unless current_user? @user
  	end

  	def admin_user
  		redirect_to root_url unless current_user.admin?
  	end
end
