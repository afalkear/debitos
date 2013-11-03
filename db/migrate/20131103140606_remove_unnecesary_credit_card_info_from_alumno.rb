class RemoveUnnecesaryCreditCardInfoFromAlumno < ActiveRecord::Migration
  def change
    remove_column :alumnos, :card_number_iv
    remove_column :alumnos, :card_number_key
  end
end
