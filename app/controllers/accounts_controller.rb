class AccountsController < ApplicationController
  def index
    if signed_in?
      @accounts = current_user.accounts
      @accounts_count = @accounts.count
      @responsible = Responsible.new
    else
      render "static_pages#home"
    end
  end

  def create
    account = Account.new(name: params[:account_name])

    if account.save
      flash[:success] = "Account added"
      redirect_to account_path(account.id)
    else
      flash[:warning] = "Error adding account: #{account.errors}"
      render 'index'
    end
  end

  def show
    account = Account.find(params[:id])
    if current_user.accounts.map(&:name).include? account.name
      @account = account
      @responsible = Responsible.new
    else
      @account = nil
    end
  end

  def edit
    account = Account.find(params[:id])
    if current_user.accounts.map(&:name).include? account.name
      @account = account
      @responsible = Responsible.new
    else
      @account = nil
    end
  end

  def destroy
    
  end
end