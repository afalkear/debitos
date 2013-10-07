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
  attr_accessible :name, :establishment, :description
  belongs_to :user
  validates :name, :inclusion => { :in => %w(visa master american),
            :message => "%You have to submit a valid credit card company" }

  has_many :alumnos

  # returns alumnos of given type (debito/credito) that should be included
  # in file
  # @param [String] type
  # @return [ActiveRecord::Relation <Alumnos>]
  def file_candidates(type)
    raise 'wrong type' if !type.in?(%W(debito credito))

    alumnos.where(card_type: type, active: true, payed: false)
  end

end
