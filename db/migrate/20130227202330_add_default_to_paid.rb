class AddDefaultToPaid < ActiveRecord::Migration
  def change
  	change_column_default :contacts, :payed, false
  end
end
