class AlumnosController < ApplicationController
  respond_to :html, :json

  def index
    @alumnos = current_user.alumnos.paginate(page: params[:page], :conditions => {:active => true})
    respond_to do |format|
      format.html
      format.csv { send_data @alumnos.to_csv }
      format.xls #{ send_data @alumnos.to_csv(col_sep: "\t") }
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
    @alumno.update_attributes(params[:alumno])
    respond_with @alumno
  end

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

end
