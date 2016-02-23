# encoding: utf-8

class ContactsController < ApplicationController
  #respond_to :html, :json
  before_filter :check_account

  def index
    @contacts = @account.contacts.where(active: true) #.page(params[:page]).order('name ASC')

    respond_to do |format|
      format.html
      format.csv { send_data Contact.to_csv(:encoding => 'utf-8') }
      format.xls
      format.json { render :json => Contact.all }
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = @account.contacts.new(params[:contact])
    if @contact.save
      flash[:success] = "Contact agregado"
      redirect_to account_contacts_path account_id: current_user.current_account_id
    else
      render 'new'
    end
  end

  def destroy
    @contact = @account.contacts.find(params[:id])
    @contact.update_attribute(:active, false)

    redirect_to contacts_path, notice: "Contact borrado"
  end

  def update
    @contact = @account.contacts.find(params[:id])

    # Strongbox leaves the same encrypted data for safety when its deleted
    if params[:contact][:secret] && (params[:contact][:secret] == "")
      @contact.update_attribute(:secret, '-')
    end


    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.html { redirect_to(@index, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@contact) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@contact) }
      end
    end
  end


  # correct headers
  #   name
  #   last_name
  #   identifier
  #   amount
  #   card_type
  #   card_company
  #   padma_id
  #   instructor
  #   plan
  #   due_date
  #   payed
  #   payment
  #   observations
  #   bill
  #   active
  #   new_debit
  #   user_id
  #   secret
  #   secret_key
  #   secret_iv
  #   card_company_id
  def import
    @account.contacts.import(params[:file], params[:bill])
    redirect_to contacts_path, notice: "Contacts importados"
  end

  def edit_multiple
    @contacts = @account.contacts.find(params[:contact_ids])
  end

  def update_multiple
    @contacts = @account.contacts.find(params[:contact_ids])
    @contacts.each do | contact |
      contact.update_attributes!(params[:contact].reject { |k,v| v.blank? })
    end
    redirect_to contacts_path, notice: "Contacts actualizados"
  end

  def delete_multiple
    @contacts = @account.contacts.find(params[:contact_ids])
    @contacts.each do | contact |
      contact.destroy
    end
    redirect_to contacts_path, notice: "Contacts eliminados"
  end

  def delete_all
    Contact.delete_all()
    redirect_to contacts_path, notice: "Todos los contacts eliminados"
  end

  def set_inactive
    @contact = @account.contacts.find(params[:id])
    @contact.update_attribute(:active, false)

    redirect_to contacts_path, notice: "Contact borrado"
  end

  def set_multiple_inactive
    @contacts = @account.contacts.find(params[:contact_ids])
    @contacts.each do | contact |
      contact.update_attribute(:active, false)
    end
    redirect_to contacts_path, notice: "Contacts borrado"
  end

  def plans
    @account.contacts.map{|c| c.synch_with_fnz}
    @contacts = @account.contacts
    @payed = @contacts.with_installment.payed
    @not_payed = @contacts.with_installment.not_payed
    @without_installment = @contacts.without_installment

    #@contacts_y_memberships = []
    #@contacts.each do |contact|
    #  m = Membership.find_current_membership(@account.name, contact.padma_id)
    #  @contacts_y_memberships << {
    #    'contact' => contact,
    #    'membership' => m,
    #    'installment' => m.nil? ? nil : m.installments.select { |i| i.due_on.to_date.month == Date.today.month}.first
    #    }
    #end

    #@memberships = Membership.find_current_memberships_for(@account.name)
  end

  def synch_with_contacts
    @account.synch_with_contacts
    redirect_to account_contacts_path(@account.id)
  end

  def check_account
    session[:return_to] = request.referer

    @account = current_user.current_account
    #if current_user.accounts.map(&:name).include? account.name
    #  @account = account
    #else
    #  @account = nil
    #  flash[:warning] = "You cannot make changes for that account"
    #  redirect_to session.delete(:return_to)
    #end
  end

  def contact_params
    params.require(:contact).permit!
  end
end
