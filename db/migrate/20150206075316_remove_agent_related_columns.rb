class RemoveAgentRelatedColumns < ActiveRecord::Migration
  def change
    drop_table :agents
    remove_reference :properties, :agent, index: true
  end
end
