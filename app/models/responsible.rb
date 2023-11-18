class Responsible < ApplicationRecord
  belongs_to :account
  has_many :card_companies
end
