class AddSecretColumnsToUser < ActiveRecord::Migration
  def change
    change_column :alumnos, :card_number, :binary
    add_column :alumnos, :card_number_key, :binary
    add_column :alumnos, :card_number_iv, :binary
  end
end
