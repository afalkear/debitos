class AddUserIdToGoogleUser < ActiveRecord::Migration
  def change
    add_column :google_users, :user_id, :integer
  end
end
