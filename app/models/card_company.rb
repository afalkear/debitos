# == Schema Information
#
# Table name: card_companies
#
#  id            :integer          not null, primary key
#  user_id       :string(255)
#  establishment :string(255)
#  description   :strinng(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#

class CardCompany < ActiveRecord::Base
  CARD_COMPANIES = %w(visa master amex)

  attr_accessible :name, :description
  belongs_to :responsible
  validates :name, :inclusion => { :in => CARD_COMPANIES,
            :message => "%{value}is not an acceptable name. You have to submit a valid credit card company" }

  has_many :contacts

  # returns contacts of given type (debito/credito) that should be included
  # in file
  # @param [String] type
  # @return [ActiveRecord::Relation <Contacts>]
  def file_candidates(type)
    raise 'wrong type' if !type.in?(%W(debito credito))

    contacts.where(card_type: type, active: true, payed: false)
  end

end
