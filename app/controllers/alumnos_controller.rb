# encoding: utf-8

class AlumnosController < ApplicationController
  respond_to :html, :json
  before_filter :check_account

  def index
    @alumnos = @account.alumnos.paginate(page: params[:page], :conditions => {:active => true})
    respond_to do |format|
      format.html
      format.csv { send_data Alumno.to_csv(:encoding => 'utf-8') }
      format.xls
      format.json { render :json => Alumno.all }
    end
  end

  def new
    @alumno = Alumno.new
  end

  def create
    @alumno = current_user.alumnos.new(params[:alumno])
    if @alumno.save
      flash[:success] = "Alumno agregado"
      redirect_to alumnos_path
    else
      render 'new'
    end
  end

  def destroy
    @alumno = current_user.alumnos.find(params[:id])
    @alumno.update_attribute(:active, false)
    
    redirect_to alumnos_path, notice: "Alumno borrado"
  end

  def update
    @alumno = current_user.alumnos.find(params[:id])

    # Strongbox leaves the same encrypted data for safety when its deleted
    if params[:alumno][:secret] && (params[:alumno][:secret] == "")
      @alumno.update_attribute(:secret, '-')
    end

    @alumno.update_attributes(params[:alumno])
    respond_with @alumno
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
    current_user.alumnos.import(params[:file], params[:bill])
    redirect_to alumnos_path, notice: "Alumnos importados"
  end

  def edit_multiple
    @alumnos = current_user.alumnos.find(params[:alumno_ids])
  end

  def update_multiple
    @alumnos = current_user.alumnos.find(params[:alumno_ids])
    @alumnos.each do | alumno |
      alumno.update_attributes!(params[:alumno].reject { |k,v| v.blank? })
    end
    redirect_to alumnos_path, notice: "Alumnos actualizados"
  end

  def delete_multiple
    @alumnos = current_user.alumnos.find(params[:alumno_ids])
    @alumnos.each do | alumno |
      alumno.destroy
    end
    redirect_to alumnos_path, notice: "Alumnos eliminados"
  end

  def delete_all
    Alumno.delete_all()
    redirect_to alumnos_path, notice: "Todos los alumnos eliminados"
  end

  def set_inactive
    @alumno = current_user.alumnos.find(params[:id])
    @alumno.update_attribute(:active, false)
    
    redirect_to alumnos_path, notice: "Alumno borrado"
  end

  def set_multiple_inactive
    @alumnos = current_user.alumnos.find(params[:alumno_ids])
    @alumnos.each do | alumno |
      alumno.update_attribute(:active, false)
    end
    redirect_to alumnos_path, notice: "Alumnos borrado"
  end

  def check_account
    session[:return_to] = request.referer

    account = Account.find(params[:account_id])
    if current_user.accounts.map(&:name).include? account.name
      @account = account
    else
      @account = nil
      flash[:warning] = "You cannot make changes for that account"
      redirect_to session.delete(:return_to)
    end
  end
end
