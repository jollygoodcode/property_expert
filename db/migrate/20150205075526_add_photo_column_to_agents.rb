class AddPhotoColumnToAgents < ActiveRecord::Migration
  def up
    remove_column :agents, :photo
    add_attachment :agents, :photo
  end

  def down
    remove_attachment :agents, :photo
    add_column :agents, :photo, :string
  end
end
