class CreateResponsibles < ActiveRecord::Migration
  def change
    create_table :responsibles do |t|
      t.integer :account_id
      t.string :username
      t.string :name

      t.timestamps
    end
  end
end
