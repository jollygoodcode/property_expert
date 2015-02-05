class RemoveColumnsFromProperties < ActiveRecord::Migration
  def up
    remove_attachment :properties, :photo_1
    remove_attachment :properties, :photo_2
    remove_attachment :properties, :photo_3
  end

  def down
    add_attachment :properties, :photo_1
    add_attachment :properties, :photo_2
    add_attachment :properties, :photo_3
  end
end
