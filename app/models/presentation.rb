class Presentation < ActiveRecord::Base
  attr_accessible :account_id, :card_company_id, :summary

  private
    def generate_visa_file(type)
      @card_company.establishment
      card_contacts = @contacts.where(card_type: type, active: true, payed: false)

      summary = generate_visa_summary(
                        type, 
                        @card_company.establishment, 
                        card_contacts.count, 
                        card_contacts.sum("amount")
                        )
      filename = if type = "credit"
                  "DEBLIQC.txt"
                else
                  "DEBLIQD.txt"
                end

      file = write_file(filename, credit_summary)
    end

    def generate_visa_summary(type, establishment, contact_count, total_amount)
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

      alumno_register_type = "1"
      alumno_reserved_space_1 = (" "*3) #.gsub(/[ ]/, '&nbsp;')
      alumno_reserved_space_2 = (" "*26) #.gsub(/[ ]/, '&nbsp;')
      transaction_code = "0005"

      total_count = contact_count.to_s.rjust(7, "0")
      total_amount = sprintf("%.02f", total_amount.to_s).rjust(16, "0").delete(".")

      first_line = begin_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                    date+hour+debit_type+status+begin_reserved+mark
      end_line = end_register_type+constant_type+credit_or_debit+" "+establishment.rjust(10, "0")+constant+
                    date+hour+total_count+total_amount+end_reserved+mark

      files = []
      alumnos.each do |alumno|
        alumno_line = alumno_register_type + 
                      alumno.card_number.to_s.rjust(16, "0")+
                      alumno_reserved_space_1+
                      alumno.bill.to_s.rjust(8, "0")+
                      date+
                      transaction_code+
                      sprintf("%.02f", alumno.amount.to_s).rjust(16, "0").delete(".")+
                      alumno.identifier.to_s.rjust(15, "0")+
                      (alumno.new_debit? ? "E" : " ")+
                      "  "+
                      alumno_reserved_space_2+
                      mark
        files << alumno_line
      end

      header = first_line 
      footer = end_line

      return [header, files, footer]
    end

    def write_file(file_name,lines_array)
      # use crlf_newline for correct newline rendering in windows
      file = File.open(file_name, mode: "w", crlf_newline: true) do |f|
        lines_array.each do |line|
          f.puts line
        end
      end
      file
    end
end
