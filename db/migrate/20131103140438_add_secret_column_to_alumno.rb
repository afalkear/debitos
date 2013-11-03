class AddSecretColumnToAlumno < ActiveRecord::Migration
  def change
    add_column :alumnos, :secret, :binary
    add_column :alumnos, :secret_key, :binary
    add_column :alumnos, :secret_iv, :binary
  end
end
