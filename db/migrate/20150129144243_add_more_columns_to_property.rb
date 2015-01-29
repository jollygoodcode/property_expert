class AddMoreColumnsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :baths, :integer
    add_column :properties, :tenure, :integer
    add_column :properties, :developer, :string
    add_column :properties, :condition, :string
  end
end
