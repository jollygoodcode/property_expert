class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    change_table(:properties) do |t|
      t.references :agent, index: true
    end
  end
end
