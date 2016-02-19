class AddActiveToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :active, :boolean, default: true
    add_column :contacts, :new, :boolean, default: true
  end
end
