class ChangeSecretToText < ActiveRecord::Migration
  def up
    change_column :contacts, :secret, :text
  end

  def down
    change_column :contacts, :secret, :binary
  end
end
