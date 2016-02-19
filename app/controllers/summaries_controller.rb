class SummariesController < ApplicationController


  def new
  end

  def show
  end

  def index
    visa_establishments = CardCompany.where(name: 'visa')
    raise 'no support for multiple establishments yet' if visa_establishments.count > 2
    @visa = visa_establishments.first

    @visa_cred = @visa.file_candidates('credito')
    @visa_deb =  @visa.file_candidates('debito')

    @master_cred = Contact.where(card_company: "MASTER", card_type: "credito", active: true, payed: false)
    @master_deb = Contact.where(card_company: "MASTER", card_type: "debito", active: true, payed: false)
    @american_cred = Contact.where(card_company: "AMERICAN", card_type: "credito", active: true, payed: false)
    @american_deb = Contact.where(card_company: "AMERICAN", card_type: "debito", active: true, payed: false)
  end

  def download
    file_name = params[:file_name] || "DEBLIQC.txt"
     
    file = File.read(file_name)
    send_data file,
              :filename => file_name,
              :type => "text/plain"
  end

  # ver si hago uno por tarjeta, pero no creo que sea conveniente.
  # lo mejor es hacer eso en forma dinámica.
  def visa_cred
    visa_establishments = CardCompany.where(name: 'visa')
    raise 'no support for multiple establishments yet' if visa_establishments.count > 2
    @visa = visa_establishments.first
    
    contacts = @visa.file_candidates('credito')
    establishment = @visa.establishment

    @visa_summary = generate_visa_summary("credit", contacts, establishment)

    write_file("DEBLIQC.txt", @visa_summary)

    @download_file = @visa_summary

    respond_to do |format|
      #format.html
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @contacts.to_csv }
      #format.xls #{ send_data @contacts.to_csv(col_sep: "\t") }
    end
  end

  def visa_deb
    visa_establishments = CardCompany.where(name: 'visa')
    raise 'no support for multiple establishments yet' if visa_establishments.count > 2
    @visa = visa_establishments.first

    contacts = @visa.file_candidates('debito')
    establishment = @visa.establishment

    @visa_summary = generate_visa_summary("debit", contacts, establishment)

    write_file("DEBLIQD.txt", @visa_summary)

    respond_to do |format|
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @contacts.to_csv }
      #format.xls #{ send_data @contacts.to_csv(col_sep: "\t") }
    end
  end

  def master_cred
    establishment = current_user.card_companies.where(name: "master").first.establishment
    contacts = Contact.where(card_company: "MASTER", active: true, payed: false)
    generate_master_file(contacts, establishment)

    respond_to do |format|
      format.html { redirect_to summaries_path, notice: "Archivo creado" }
      #format.csv { send_data @contacts.to_csv }
      #format.xls #{ send_data @contacts.to_csv(col_sep: "\t") }
    end
  end

  def generate_visa_summary(type, contacts, establishment)
    if type == "credit"
      filename = "DEBLIQC"
    else
      filename = "DEBLIQD"
    end
    begin_register_type = "0"
    end_register_type = "9"
    constant_type = "DEBLIQ"
    establishment = establishment #"3617131"
    constant = "900000    " #.gsub(/[ ]/, '&nbsp;')
    date = Time.now.year.to_s.rjust(4,"0")+Time.now.month.to_s.rjust(2, "0")+Time.now.day.to_s.rjust(2, "0")
    date = date #.gsub(/[ ]/, '&nbsp;')
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0") #.gsub(/[ ]/, '&nbsp;')
    debit_type = "0"
    status = "  " #.gsub(/[ ]/, '&nbsp;')
    begin_reserved = " "*55
    end_reserved = " "*36
    mark = "*"
    credit_or_debit = (type == "credit" ? "C" : "D")

    contact_register_type = "1"
    contact_reserved_space_1 = (" "*3) #.gsub(/[ ]/, '&nbsp;')
    contact_reserved_space_2 = (" "*26) #.gsub(/[ ]/, '&nbsp;')
    transaction_code = "0005"


    total_count = contacts.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", contacts.sum("amount").to_s).rjust(16, "0").delete(".")
    # filename = DEBLIQ + "C" if params[:type => "credito"] algo así
    first_line = begin_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+debit_type+status+begin_reserved+mark
    end_line = end_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+total_count+total_amount+end_reserved+mark

    files = []
    contacts.each do |contact|
      contact_line = contact_register_type + 
                    contact.card_number.to_s.rjust(16, "0")+
                    contact_reserved_space_1+
                    contact.bill.to_s.rjust(8, "0")+
                    date+
                    transaction_code+
                    sprintf("%.02f", contact.amount.to_s).rjust(16, "0").delete(".")+
                    contact.identifier.to_s.rjust(15, "0")+
                    (contact.new_debit? ? "E" : " ")+
                    "  "+
                    contact_reserved_space_2+
                    mark
      files << contact_line
    end
    

    header = first_line #[begin_register_type,constant_type,credit_or_debit," ",establishment.rjust(10, "0"),constant,
                  # date,hour,debit_type,status,begin_reserved,mark]
    footer = end_line #[end_register_type,constant_type,credit_or_debit," ",establishment.rjust(10, "0"),constant,
                  # date,hour,total_count,total_amount,end_reserved,mark]
    return [header, files, footer]
  end

  # TODO este parece ser una version vieja de generate_visa_summary
  def generate_visa_file(type, contacts, establishment)
    if type == "credit"
      filename = "DEBLIQC"
    else
      filename = "DEBLIQD"
    end
    begin_register_type = "0"
    end_register_type = "9"
    constant_type = "DEBLIQ"
    establishment = establishment #"3617131"
    constant = "900000    "
    date = Time.now.year.to_s.rjust(4,"0")+Time.now.month.to_s.rjust(2, "0")+Time.now.day.to_s.rjust(2, "0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")
    debit_type = "0"
    status = "  "
    begin_reserved = " "*55
    end_reserved = " "*36
    mark = "*"
    credit_or_debit = (type == "credit" ? "C" : "D")

    contact_register_type = "1"
    contact_reserved_space_1 = " "*3
    contact_reserved_space_2 = " "*26
    transaction_code = "0005"


    total_count = contacts.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", contacts.sum("amount").to_s).rjust(16, "0").delete(".")
    # filename = DEBLIQ + "C" if params[:type => "credito"] algo así
    first_line = begin_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+debit_type+status+begin_reserved+mark
    end_line = end_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                  date+hour+total_count+total_amount+end_reserved+mark

    File.open(filename, "w") do |f|
      f.puts(first_line)
      contacts.each do |contact|
        contact_line = contact_register_type +
                      contact.card_number.to_s.rjust(16, "0") + 
                      contact_reserved_space_1 + 
                      contact.bill.to_s.rjust(8, "0") +
                      date + 
                      transaction_code + 
                      sprintf("%.02f", contact.amount.to_s).rjust(16, "0").delete(".") + 
                      contact.identifier.to_s.rjust(15, "0") +
                      (contact.new_debit? ? "E" : " ") + 
                      "  " + 
                      contact_reserved_space_2 + 
                      mark
        f.puts(contact_line)
      end
      f.puts(end_line)
    end
  end

  def generate_master_file(contacts, establishment)
    date = Date.today
    filename = date.strftime("%B")
    establishment = establishment #"3617131"
    date = Time.now.day.to_s.rjust(2, "0") + Time.now.month.to_s.rjust(2, "0") + Time.now.year.to_s.rjust(2,"0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")

    total_count = contacts.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", contacts.sum("amount").to_s).rjust(14, "0").delete(".")
    first_line = establishment.rjust(8, "0") + "1" + date + total_count + "0" + total_amount + " "*91

    File.open(filename, "w") do |f|
      f.puts(first_line)
      contacts.each do |contact|
        contact_line = establishment.rjust(8, "0") +
                      "2" + 
                      contact.card_number.to_s.rjust(16, "0") + 
                      contact.identifier.to_s.rjust(12, "0") +
                      "001" + 
                      "999" + 
                      "01" + 
                      sprintf("%.02f", contact.amount.to_s).rjust(11, "0").delete(".") + 
                      Time.now.month.to_s.rjust(5, "0") + #TODO averiguar que es este campo "PERIODO" 
                      " " +
                      date + 
                      " "*40 + 
                      " "*20
        f.puts(contact_line)
      end
      f.puts(end_line)
    end
  end

  def write_file(file_name,lines_array)
    # use crlf_newline for correct newline rendering in windows
    File.open(file_name, mode: "w", crlf_newline: true) do |f|
      lines_array.each do |line|
        f.puts line
      end
    end
  end

  def generate_amex_file(contacts, establishment)
    date = Date.today
    filename = date.strftime("%B")
    establishment = establishment #"3617131"
    date = Time.now.day.to_s.rjust(2, "0") + Time.now.month.to_s.rjust(2, "0") + Time.now.year.to_s.rjust(2,"0")
    hour = Time.now.hour.to_s.rjust(2, "0")+Time.now.min.to_s.rjust(2, "0")

    total_count = contacts.count.to_s.rjust(7, "0")
    total_amount = sprintf("%.02f", contacts.sum("amount").to_s).rjust(14, "0").delete(".")
    first_line = establishment.rjust(8, "0") + "1" + date + total_count + "0" + total_amount + " "*91

    File.open(filename, "w") do |f|
      f.puts(first_line)
      contacts.each do |contact|
        contact_line = establishment.rjust(10, "0") +
                      contact.card_number.to_s.rjust(15, "0") + 
                      contact.identifier.to_s.rjust(5, "0") + #TODO Averiguar bien estos dos campos, código de servicio y número de servicio
                      contact.identifier.to_s.rjust(10, "0") +
                      "01" + 
                      Time.now.year.to_s.rjust(2,"0") + Time.now.month.to_s.rjust(2, "0") + 
                      sprintf("%.02f", contact.amount.to_s).rjust(11, "0").delete(".") + 
                      Time.now.year.to_s.rjust(2,"0") + "-" + Time.now.month.to_s.rjust(2, "0") + 
                      " "*38
        f.puts(contact_line)
      end
      f.puts(end_line)
    end
  end
end
