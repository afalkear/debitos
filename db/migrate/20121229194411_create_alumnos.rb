class CreateAlumnos < ActiveRecord::Migration
  def change
    create_table :alumnos do |t|
      t.string :name
      t.string :last_name
      t.string :identifier
      t.decimal :amount, precision: 8, scale: 2
      t.string :card_number
      t.string :card_type
      t.string :card_company

      t.timestamps
    end
  end
end
