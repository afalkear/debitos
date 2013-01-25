class CreateGoogleUsers < ActiveRecord::Migration
  def change
    create_table :google_users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
