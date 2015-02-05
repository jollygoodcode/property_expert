class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.attachment :file
      t.references :owner, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
