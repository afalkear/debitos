# == Schema Information
#
# Table name: card_companies
#
#  id            :integer          not null, primary key
#  user_id       :string(255)
#  establishment :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#

class CardCompany < ActiveRecord::Base
  attr_accessible :name, :establishment
  belongs_to :user
  validates :name, :inclusion => { :in => %w(visa master american),
            :message => "%You have to submit a valid credit card company" }
end
