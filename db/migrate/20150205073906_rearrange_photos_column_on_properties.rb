class RearrangePhotosColumnOnProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :photo_1
    remove_column :properties, :photo_2
    remove_column :properties, :photo_3

    add_attachment :properties, :photo_1
    add_attachment :properties, :photo_2
    add_attachment :properties, :photo_3
  end

  def down
    remove_attachment :properties, :photo_1
    remove_attachment :properties, :photo_2
    remove_attachment :properties, :photo_3

    add_column :properties, :photo_1, :string
    add_column :properties, :photo_2, :string
    add_column :properties, :photo_3, :string
  end
end
