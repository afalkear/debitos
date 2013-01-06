class AddBillToAlumno < ActiveRecord::Migration
  def change
    add_column :alumnos, :bill, :string
  end
end
