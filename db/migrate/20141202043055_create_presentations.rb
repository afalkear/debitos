class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.integer :account_id
      t.integer :card_company_id
      t.text :summary

      t.timestamps
    end
  end
end
