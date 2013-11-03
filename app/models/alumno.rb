#

# == Schema Information
#
# Table name: alumnos
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  last_name    :string(255)
#  identifier   :string(255)
#  amount       :decimal(8, 2)
#  card_number  :string(255)
#  card_type    :string(255)
#  card_company :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  padma_id     :string(255)
#  instructor   :string(255)
#  plan         :string(255)
#  due_date     :string(255)
#  payed        :boolean          default(FALSE)
#  payment      :string(255)
#  observations :string(255)
#  bill         :string(255)
#  active       :boolean          default(TRUE)
#  new_debit    :boolean          default(TRUE)
#

class Alumno < ActiveRecord::Base
  attr_accessible :amount, :card_company, :card_number, :card_type, :identifier, :last_name, :name, 
    :instructor, :plan, :due_date, :payed, :payment, :observations, :bill, :new_debit, :active, :secret
  validates :name, presence: true
  encrypt_with_public_key :secret, :key_pair => Rails.root.join('config', 'keypair.pem')
  belongs_to :user

  def new_debit?
    self.new_debit
  end

  def set_inactive
    self.active = false
  end

  def number_for_humans
    if self.secret.nil?
      return ""
    end
    self.secret.decrypt('este establecimiento es propiedad de lucia gagliardini')
  end

  def self.import(file, bill)
    bill_number = bill.to_i
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      alumno = find_by_id(row["id"]) || new
      #alumno.attributes = row.to_hash.slice(*accessible_attributes)
      att = %w(name instructor plan amount due_date payed payment observations)

      # instead of an iterator put an array of strings with the name of the columns, in case they change
      # eg: column = %w("Nombre completo" Instructor Plan Monto "Fecha de vencimiento:" ....etc)
      i=0
      attributes = {
          "name" => nil,
          "instructor" => nil,
          "plan" => nil,
          "amount" => nil,
          "due_date" => nil,
          "payed" => false,
          "payment" => nil,
          "observations" => nil,
          "active" => true,
          "user_id" => current_user.id
        }
      row.each do |k, v|
        attributes[att[i]] = v
        #alumno.update_attribute(att[i], v)
        i+=1
      end

      attributes["bill"] = bill_number
      bill_number+=1
      update_card_attributes(attributes)
      alumno.update_attributes(attributes)
      alumno.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |alumno|
        csv << alumno.attributes.values_at(*column_names)
      end
    end
  end

  private
    # TODO! Pensar mejor este method para que no se sobreescriban
    def find_by_padma_id(id)
      Alumno.where(padma_id: id) unless id.nil?
    end

    def self.update_card_attributes(attributes)
      # !TODO! sacar esto, es sólo para hacer pruebas
      attributes["card_number"] = (1_000_000_000_000_000 + Random.rand(10_000_000_000_000_000 - 1_000_000_000_000_000)).to_s

      payment = attributes["payment"].downcase
      # check for company
      if payment.match(/visa/)
        attributes["card_company"] = "VISA"
        #alumno.update_attribute("card_company", "VISA")
      elsif payment.match(/master/)
        attributes["card_company"] = "MASTER"
      elsif payment.match(/american/) || payment.match(/amex/)
        attributes["card_company"] = "AMERICAN"
      else
        attributes["card_company"] = "UNKNOWN"
      end

      if payment.match(/cred/)
        attributes["card_type"] = "credito"
      else
        attributes["card_type"] = "debito"
      end
    end
end
