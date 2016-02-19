class LinkContactWithCardCompany < ActiveRecord::Migration
  def change
    add_column :contacts, :card_company_id, :integer
  end
end
