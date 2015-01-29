class CreateAgent < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :company
      t.string :mobile
      t.string :email
      t.string :photo

      t.timestamps null: false
    end
  end
end
