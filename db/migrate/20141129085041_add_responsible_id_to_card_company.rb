class AddResponsibleIdToCardCompany < ActiveRecord::Migration
  def change
    add_column :card_companies, :responsible_id, :integer
    remove_column :card_companies, :user_id
  end
end
