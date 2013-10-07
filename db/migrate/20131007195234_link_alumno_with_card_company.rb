class LinkAlumnoWithCardCompany < ActiveRecord::Migration
  def change
    add_column :alumnos, :card_company_id, :integer
  end
end
