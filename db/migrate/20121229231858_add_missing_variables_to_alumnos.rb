class AddMissingVariablesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :instructor, :string
    add_column :contacts, :plan, :string
    add_column :contacts, :due_date, :string
    add_column :contacts, :payed, :boolean
    add_column :contacts, :payment, :string
    add_column :contacts, :observations, :string
  end
end
