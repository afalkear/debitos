class ChangeSecretToText < ActiveRecord::Migration
  def up
    change_column :alumnos, :secret, :text
  end

  def down
    change_column :alumnos, :secret, :binary
  end
end
