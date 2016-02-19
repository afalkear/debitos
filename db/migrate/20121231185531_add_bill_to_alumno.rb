class AddBillToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :bill, :string
  end
end
