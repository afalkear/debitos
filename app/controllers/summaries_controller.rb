class SummariesController < ApplicationController
  def new
  end

  def show
  end

  def index
    @visa_cred = Alumno.where(card_company: "VISA", card_type: "credito", active: true, payed: false)
    @visa_deb = Alumno.where(card_company: "VISA", card_type: "debito", active: true, payed: false)
    @master_cred = Alumno.where(card_company: "MASTER", card_type: "credito", active: true, payed: false)
    @master_deb = Alumno.where(card_company: "MASTER", card_type: "debito", active: true, payed: false)
    @american_cred = Alumno.where(card_company: "AMERICAN", card_type: "credito", active: true, payed: false)
    @american_deb = Alumno.where(card_company: "AMERICAN", card_type: "debito", active: true, payed: false)
  end

  # ver si hago uno por tarjeta, pero no creo que sea conveniente.
  # lo mejor es hacer eso en forma dinámica.
  def visa_cred
    alumnos = Alumno.where(card_company: "VISA", card_type: "credito", active: true, payed: false)
    generate_visa_file("credit", alumnos)

    respond_to do |format|
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @alumnos.to_csv }
      #format.xls #{ send_data @alumnos.to_csv(col_sep: "\t") }
    end
  end

  def visa_deb
    alumnos = Alumno.where(card_company: "VISA", card_type: "debito", active: true, payed: false)
    generate_visa_file("debit", alumnos)

    respond_to do |format|
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @alumnos.to_csv }
      #format.xls #{ send_data @alumnos.to_csv(col_sep: "\t") }
    end
  end

  def master_cred
    alumnos = Alumno.where(card_company: "MASTER", active: true, payed: false)
    generate_master_file(alumnos)

    respond_to do |format|
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @alumnos.to_csv }
      #format.xls #{ send_data @alumnos.to_csv(col_sep: "\t") }
    end
  end

  def generate_visa_file(type, alumnos)
    if type == "credit"
      filename = "DEBLIQC"
    else
      filename = "DEBLIQD"
    end
    begin_register_type = "0"
    end_register_type = "9"
    constant_type = "DEBLIQ"
    establishment = "3617131"
    constant = "900000    "
    date = Time.now.year.to_s.rjust(4,"0")+Time.now.month.to_s.rjust(2, "0")+Time.now.day.to_s.rjust(2, "0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")
    debit_type = "0"
    status = "  "
    begin_reserved = " "*55
    end_reserved = " "*36
    mark = "*"
    credit_or_debit = (type == "credit" ? "C" : "D")

    alumno_register_type = "1"
    alumno_reserved_space_1 = " "*3
    alumno_reserved_space_2 = " "*26
    transaction_code = "0005"


    total_count = alumnos.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", alumnos.sum("amount").to_s).rjust(16, "0").delete(".")
    # filename = DEBLIQ + "C" if params[:type => "credito"] algo así
    first_line = begin_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+debit_type+status+begin_reserved+mark
    end_line = end_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+total_count+total_amount+end_reserved+mark

    File.open(filename, "w") do |f|
      f.puts(first_line)
      alumnos.each do |alumno|
        alumno_line = alumno_register_type +
                      alumno.card_number.to_s.rjust(16, "0") + 
                      alumno_reserved_space_1 + 
                      alumno.bill.to_s.rjust(8, "0") +
                      date + 
                      transaction_code + 
                      sprintf("%.02f", alumno.amount.to_s).rjust(16, "0").delete(".") + 
                      alumno.identifier.to_s.rjust(15, "0") +
                      (alumno.new_debit? ? "E" : " ") + 
                      "  " + 
                      alumno_reserved_space_2 + 
                      mark
        f.puts(alumno_line)
      end
      f.puts(end_line)
    end
  end

  def generate_master_file(alumnos)
    date = Date.today
    filename = date.strftime("%B")
    establishment = "3617131"
    date = Time.now.day.to_s.rjust(2, "0") + Time.now.month.to_s.rjust(2, "0") + Time.now.year.to_s.rjust(2,"0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")

    total_count = alumnos.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", alumnos.sum("amount").to_s).rjust(14, "0").delete(".")
    first_line = establishment.rjust(8, "0") + "1" + date + total_count + "0" + total_amount + " "*91

    File.open(filename, "w") do |f|
      f.puts(first_line)
      alumnos.each do |alumno|
        alumno_line = establishment.rjust(8, "0") +
                      "2" + 
                      alumno.card_number.to_s.rjust(16, "0") + 
                      alumno.identifier.to_s.rjust(12, "0") +
                      "001" + 
                      "999" + 
                      "01" + 
                      sprintf("%.02f", alumno.amount.to_s).rjust(11, "0").delete(".") + 
                      Time.now.month.to_s.rjust(5, "0") + #TODO averiguar que es este campo "PERIODO" 
                      " " +
                      date + 
                      " "*40 + 
                      " "*20
        f.puts(alumno_line)
      end
      f.puts(end_line)
    end
  end

  def generate_amex_file(alumnos)
    date = Date.today
    filename = date.strftime("%B")
    establishment = "3617131"
    date = Time.now.day.to_s.rjust(2, "0") + Time.now.month.to_s.rjust(2, "0") + Time.now.year.to_s.rjust(2,"0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")

    total_count = alumnos.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", alumnos.sum("amount").to_s).rjust(14, "0").delete(".")
    first_line = establishment.rjust(8, "0") + "1" + date + total_count + "0" + total_amount + " "*91

    File.open(filename, "w") do |f|
      f.puts(first_line)
      alumnos.each do |alumno|
        alumno_line = establishment.rjust(10, "0") +
                      alumno.card_number.to_s.rjust(15, "0") + 
                      alumno.identifier.to_s.rjust(5, "0") + #TODO Averiguar bien estos dos campos, código de servicio y número de servicio
                      alumno.identifier.to_s.rjust(10, "0") +
                      "01" + 
                      Time.now.year.to_s.rjust(2,"0") + Time.now.month.to_s.rjust(2, "0") + 
                      sprintf("%.02f", alumno.amount.to_s).rjust(11, "0").delete(".") + 
                      Time.now.year.to_s.rjust(2,"0") + "-" + Time.now.month.to_s.rjust(2, "0") + 
                      " "*38
        f.puts(alumno_line)
      end
      f.puts(end_line)
    end
  end
end