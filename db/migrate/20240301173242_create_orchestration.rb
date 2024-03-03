class CreateOrchestration < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestrations do |t|
      t.string :status
      t.references :episode, foreign_key: true

      t.timestamps
    end

    add_reference :execution_processes, :orchestration, foreign_key: { to_table: :orchestrations }
  end
end
