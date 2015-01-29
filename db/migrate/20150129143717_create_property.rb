class CreateProperty < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string  :name
      t.string  :property_type
      t.integer :price
      t.integer :size
      t.text    :description
      t.string  :postal_code
      t.string  :street
      t.integer :bedrooms
      t.string  :photo_1
      t.string  :photo_2
      t.string  :photo_3

      t.timestamps null: false
    end
  end
end
