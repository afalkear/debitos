class AddSecretColumnsToUser < ActiveRecord::Migration
  def change
    add_column :alumnos, :card_number_key, :binary
    add_column :alumnos, :card_number_iv, :binary
  end
end
