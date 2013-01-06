class ChangeNewAttributeName < ActiveRecord::Migration
  def up
    add_column :alumnos, :new_debit, :boolean, :default => true
    remove_column :alumnos, :new
  end

  def down
    add_column :alumnos, :new, :boolead, :default => true
    remove_column :alumnos, :new_debit
  end
end
