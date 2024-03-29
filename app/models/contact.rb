# encoding: utf-8
#

# == Schema Information
#
# Table name: contacts
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

# @attribute active [Booelan] used for soft-delete. false means contact has been "deleted"
class Contact < ApplicationRecord
  #attr_accessor :secret_value
  validates :name, presence: true
  encrypt_with_public_key :secret,
                          :base64 => true,
                          :key_pair => Rails.root.join('config', 'keypair.pem')
  belongs_to :account

  belongs_to :card_company

  validates_length_of :identifier, maximum: 15
  validates_uniqueness_of :identifier, :allow_blank => true, :allow_nil => true, scope: :account_id

  before_validation :fill_identifier

  scope :payed, -> { where(payed: true) }
  scope :not_payed, -> { where(payed: false) }
  scope :without_installment,  -> { where(amount: nil) }
  scope :with_installment, -> { where('amount is not null') }

  def new_debit?
    self.new_debit
  end

  def secret_value=(value)
    self.secret = value
    self.save
  end

  def secret_value
    self.secret.nil? ? "" : self.number_for_humans
  end

  def set_inactive
    self.active = false
  end

  def number_for_humans
    if self.secret.nil?
      return ""
    end
    self.secret.decrypt(ENV['PHRASE'])
  end

  def full_name
    "#{name} #{last_name}"
  end

  def synch_with_fnz
    m = Membership.find_current_membership(account.name, padma_id)
    self.card_type = m.nil? ? nil : m.payment_type
    self.amount = m.nil? ? nil : m.installments.select { |i| i.due_on.to_date.month == Date.today.month}.first.value
    status = m.nil? ? nil : m.installments.select { |i| i.due_on.to_date.month == Date.today.month}.first.status
    self.payed = status.nil? ? nil : (status == "incomplete" ? false : true)
    self.save
  end

  def self.import(file, bill)
    # TODO this number should not be passed as an argument, at least not as an obligatory argument
    bill_number = bill.nil? ? bil.to_i : nil

    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      contact = find_by_id(row["id"]) || new
      contact[:secret] = Base64.decode64(row['secret'])
      contact[:secret_key] = Base64.decode64(row['secret_key'])
      contact[:secret_iv] = Base64.decode64(row['secret_iv'])

      contact.bill = bill_number
      bill_number+=1 unless bill_number.nil?
      # update_card_attributes(attributes)
      # contact.update_attributes(attributes)
      contact.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.to_csv(options = {})
    # options = options.merge(encoding: "utf-8:utf-8")
    CSV.generate(options) do |csv|
      csv << ['id', 'secret', 'secret_key', 'secret_iv']
      Contact.all.each do |contact|
        contact_data = [contact.id,
                       Base64.strict_encode64(contact[:secret]),
                       Base64.strict_encode64(contact[:secret_key]),
                       Base64.strict_encode64(contact[:secret_iv])
        ]
        csv << contact_data
      end
    end
  end

  def as_json(options={})
    {:contact => {:id => self.id, :secret => Base64.strict_encode64(self[:secret])}}
  end

  private
    # TODO! Pensar mejor este method para que no se sobreescriban
    def find_by_padma_id(id)
      Contact.where(padma_id: id) unless id.nil?
    end

    def self.update_card_attributes(attributes)
      # !TODO! sacar esto, es sólo para hacer pruebas
      attributes["card_number"] = (1_000_000_000_000_000 + Random.rand(10_000_000_000_000_000 - 1_000_000_000_000_000)).to_s

      payment = attributes["payment"].downcase
      # check for company
      if payment.match(/visa/)
        attributes["card_company"] = "VISA"
        #contact.update_attribute("card_company", "VISA")
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

    def self.get_value_for(field, row)
      row[field].blank? ? nil : row[field]
    end

    def fill_identifier
      self.identifier = self.identifier.rjust(15, '0') unless self.identifier.nil?
    end
end
