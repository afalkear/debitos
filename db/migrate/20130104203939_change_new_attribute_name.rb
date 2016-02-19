class ChangeNewAttributeName < ActiveRecord::Migration
  def up
    add_column :contacts, :new_debit, :boolean, :default => true
    remove_column :contacts, :new
  end

  def down
    add_column :contacts, :new, :boolead, :default => true
    remove_column :contacts, :new_debit
  end
end
