class Responsible < ActiveRecord::Base
  attr_accessible :account_id, :username, :name

  belongs_to :account
  has_many :card_companies
end
