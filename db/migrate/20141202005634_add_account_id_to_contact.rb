class AddAccountIdToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :account_id, :integer
    remove_column :contacts, :user_id
  end
end
