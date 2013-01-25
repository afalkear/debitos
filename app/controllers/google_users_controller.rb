class GoogleUsersController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :update]

  def index

  end

  def create
    @google_user = current_user.google_users.build(params[:google_user])
    if @google_user.save
      flash[:success] = "Google User Created"
      redirect_to user_path(current_user)
    else
      flash[:]
    end
  end

  def destroy

  end

end