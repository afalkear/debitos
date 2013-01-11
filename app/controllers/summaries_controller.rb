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
  def visa
    alumnos = Alumno.where(card_company: "VISA", card_type: "credito")
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

    alumno_register_type = "1"
    alumno_reserved_space_1 = " "*3
    alumno_reserved_space_2 = " "*26
    transaction_code = "0005"


    total_count = alumnos.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", alumnos.sum("amount").to_s).rjust(16, "0").delete(".")
    # filename = DEBLIQ + "C" if params[:type => "credito"] algo así
    first_line = begin_register_type+constant_type+"C"+" "+establishment.rjust(10, "0")+constant+
                  date+hour+debit_type+status+begin_reserved+mark
    end_line = end_register_type+constant_type+"C"+" "+establishment.rjust(10, "0")+constant+
                  date+hour+total_count+total_amount+end_reserved+mark

    File.open("text.txt", "w") do |f|
      f.puts(first_line)
      alumnos.each do |alumno|
        alumno_line = alumno_register_type+alumno.card_number.to_s.rjust(16, "0")+alumno_reserved_space_1+alumno.bill.to_s.rjust(8, "0")+
                      date+transaction_code+sprintf("%.02f", alumno.amount.to_s).rjust(16, "0").delete(".")+alumno.identifier.to_s.rjust(15, "0")+
                      (alumno.new_debit? ? "E" : " ")+"  "+alumno_reserved_space_2+mark
        f.puts(alumno_line)
      end
      f.puts(end_line)
    end
    redirect_to summaries_path, notice: "Archivo creado"
  end
end