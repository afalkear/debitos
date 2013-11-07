class AddEstablishmentDescription < ActiveRecord::Migration
  def change
    add_column :card_companies, :description, :string
  end
end
