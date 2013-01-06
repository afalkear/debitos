class AddPadmaIdToAlumnos < ActiveRecord::Migration
  def change
    add_column :alumnos, :padma_id, :string
  end
end
