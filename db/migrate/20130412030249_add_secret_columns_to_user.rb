class AddSecretColumnsToUser < ActiveRecord::Migration
  def change
    add_column :contacts, :card_number_key, :binary
    add_column :contacts, :card_number_iv, :binary
  end
end
