class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]

  def new
    @user = User.new
    @user.card_companies.build
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @user.card_companies.build
    # TODO! let user do this if he is currently signed in
    @google_user = @user.google_users.last || @user.google_users.build
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:succes] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:succes] = "User destroyed."
    redirect_to users_url
  end

  def main
    #@google_session = GoogleDrive.login("alex.falke@uni-yoga.com.br", "deutsche_alex_f4lk3!")
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
