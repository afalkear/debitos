class AccountsController < ApplicationController
  def index
    @accounts = current_user.accounts
    @accounts_count = @accounts.count
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
    else
      @account = nil
    end
  end

  def destroy
    
  end
end