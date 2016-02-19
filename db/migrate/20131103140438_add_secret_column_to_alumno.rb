class AddSecretColumnToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :secret, :binary
    add_column :contacts, :secret_key, :binary
    add_column :contacts, :secret_iv, :binary
  end
end
