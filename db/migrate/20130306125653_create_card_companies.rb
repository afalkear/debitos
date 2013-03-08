class CreateCardCompanies < ActiveRecord::Migration
  def change
    create_table :card_companies do |t|
      t.string :user_id
      t.string :establishment

      t.timestamps
    end
  end
end
