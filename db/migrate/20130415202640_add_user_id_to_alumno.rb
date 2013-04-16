class AddUserIdToAlumno < ActiveRecord::Migration
  def change
    add_column :alumnos, :user_id, :integer
  end
end
