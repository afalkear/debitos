class ResponsiblesController < ApplicationController
  #TODO add more security, check if the user can manage this model

  def index

  end

  def new
    @responsible = Responsible.new
  end

  def create
    # session[:return_to] = request.referer

    account = Account.find(params[:account_id])

    @responsible = account.responsibles.new(params[:responsible])
    if @responsible.save
      flash[:success] = "New responsible added"
      redirect_to responsible_path(@responsible.id)
    else
      flash[:error] = "Could not create responsible due to: #{@responsible.errors}"
      render "new"
    end
  end

  def show
    @responsible = Responsible.find(params[:id])
    @card_company = CardCompany.new
    @available_card_companies = CardCompany::CARD_COMPANIES - @responsible.card_companies.map {|c| c.name}
  end

  def edit
    @responsible = Responsible.find(params[:id])
  end

  def update
    @responsible = Responsible.find(params[:id])
    if @responsible.update(responsible_params)
      flash[:success] = "Updated"
      redirect_to responsible_path(@responsible.id)
    else
      flash[:error] = "Could not update responsible due to: #{@responsible.errors}"
      redirect_to responsible_path(@responsible.id)
    end
  end

  def destroy
    @responsible = Responsible.find(params[:id])
    @responsible.destroy
  end

  def responsible_params
    params.require(:responsible).permit!
  end
end
