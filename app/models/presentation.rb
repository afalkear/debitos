class Presentation < ApplicationRecord

  def generate_file(card_company, card_type, contacts)
    filename = generate_visa_file(card_company, card_type, contacts)
  end

  private
    def generate_visa_file(card_company, type, contacts)
      summary = generate_visa_summary(
                        type,
                        card_company.establishment,
                        contacts.count,
                        contacts.sum(&:amount),
                        contacts
                        )
      filename = if type == "credit"
                  "DEBLIQC.txt"
                else
                  "DEBLIQD.txt"
                end

      write_file(filename, summary)
      filename
    end

    def generate_visa_summary(type, establishment, contact_count, total_amount, contacts)
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

      total_count = contact_count.to_s.rjust(7, "0")
      total_amount = sprintf("%.02f", total_amount.to_s).rjust(16, "0").delete(".")

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
