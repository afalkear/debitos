class PresentationsController < ApplicationController
  before_filter :check_account

  def index
    @presentations = @account.presentations
  end

  def show
    @presentation = Presentation.find(params[:id])
  end

  def new
    #@card_company = CardCompany.find(params[:card_company_id])
    @presentation = Presentation.new
    @contacts = Contact.find(params[:contact][:ids])
  end

  def create
    @presentation = Presentation.create(params[:presentation])
    @presentation.generate_visa_file("credit")
  end

  def edit
    @presentation = Presentation.find(params[:id])
  end

  def update
    @presentation = Presentation.find(params[:id])
  end

  def destroy
    @presentation = Presentation.find(params[:id])
    presentation.destroy
  end

  def download
    file = generate_visa_file(params[:card_company][:card_type])

    if !file.nil?
      send_file(file.path)
    else
      flash[:warning] = "Summary was not created"
      render "new"
    end
  end

  def check_account
    @account = current_user.current_account
    #session[:return_to] = request.referer

    #account = Account.find(params[:account_id])
    #if current_user.accounts.map(&:name).include? account.name
   #   @account = account
    #else
    #  @account = nil
    #  flash[:warning] = "You cannot make changes for that account"
    #  redirect_to session.delete(:return_to)
    #end
  end
end
