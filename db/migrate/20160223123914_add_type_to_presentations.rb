class AddTypeToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :type, :string
  end
end
