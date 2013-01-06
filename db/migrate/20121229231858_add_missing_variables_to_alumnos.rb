class AddMissingVariablesToAlumnos < ActiveRecord::Migration
  def change
    add_column :alumnos, :instructor, :string
    add_column :alumnos, :plan, :string
    add_column :alumnos, :due_date, :string
    add_column :alumnos, :payed, :boolean
    add_column :alumnos, :payment, :string
    add_column :alumnos, :observations, :string
  end
end
