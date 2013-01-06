class AddActiveToAlumnos < ActiveRecord::Migration
  def change
    add_column :alumnos, :active, :boolean, default: true
    add_column :alumnos, :new, :boolean, default: true
  end
end
