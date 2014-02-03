class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    
  end

  def update
    update_success = @user.update_attributes(user_params)
    if update_success
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "User '#{user.name}' deleted."
    redirect_to users_url
  end

  private
  
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #Before filters

  def signed_in_user
    if !signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      flash[:error] = "Unauthorized access"
      redirect_to(root_url)
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
