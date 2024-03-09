class AddCanceledAtToOrchestrations < ActiveRecord::Migration[7.1]
  def change
    add_column :orchestrations, :canceled_at, :datetime, null: true
  end
end
