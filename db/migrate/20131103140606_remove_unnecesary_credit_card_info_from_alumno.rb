class RemoveUnnecesaryCreditCardInfoFromContact < ActiveRecord::Migration
  def change
    remove_column :contacts, :card_number_iv
    remove_column :contacts, :card_number_key
  end
end
