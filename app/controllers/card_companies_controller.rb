class CardCompaniesController < ApplicationController
  def create
    session[:return_to] = request.referer

    responsible = Responsible.find(params[:responsible_id])
    card_company = responsible.card_companies.new(params[:card_company])

    if card_company.save
      flash[:success] = "Card company created"
      redirect_to session[:return_to]
    else
      flash[:warning] = "Card company not created due to: #{card_company.errors.full_messages.join(". ")}"
      redirect_to session.delete(:return_to)
    end
  end

  def destroy
    @card_company = CardCompany.find(params[:id])
    flash[:success] = "Card company deleted"
    @card_company.destroy
  end

  def card_companies_params
    # insert here the allowed params
    # params.permit(:id)
  end
end
