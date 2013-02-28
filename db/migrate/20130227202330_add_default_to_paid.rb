class AddDefaultToPaid < ActiveRecord::Migration
  def change
  	change_column_default :alumnos, :payed, false
  end
end
