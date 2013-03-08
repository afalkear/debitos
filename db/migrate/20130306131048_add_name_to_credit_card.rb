class AddNameToCreditCard < ActiveRecord::Migration
  def change
    add_column :card_companies, :name, :string
  end
end
