class CreateExecutionProcesses < ActiveRecord::Migration[7.1]
  def change
    create_table :execution_processes do |t|
      t.string :status
      t.string :handle
      t.text :command_string
      t.json :output
      t.references :episode, foreign_key: true

      t.datetime :completed_at
      t.timestamps
    end

    add_reference :execution_processes, :previous_execution_process, foreign_key: { to_table: :execution_processes }
  end
end
