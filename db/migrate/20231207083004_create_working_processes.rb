class CreateWorkingProcesses < ActiveRecord::Migration[6.1]
  def change
    create_table :working_processes do |t|
      t.references :type_of_task, null: false, foreign_key: true
      t.integer :workload
      t.float :working_hour
      t.integer :unit

      t.timestamps
    end
  end
end
