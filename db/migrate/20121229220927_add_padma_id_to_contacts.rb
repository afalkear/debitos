class AddPadmaIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :padma_id, :string
  end
end
