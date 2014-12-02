class AddAccountIdToAlumno < ActiveRecord::Migration
  def change
    add_column :alumnos, :account_id, :integer
    remove_column :alumnos, :user_id
  end
end
