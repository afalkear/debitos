class Responsible < ActiveRecord::Base
  belongs_to :account
  has_many :card_companies
end
