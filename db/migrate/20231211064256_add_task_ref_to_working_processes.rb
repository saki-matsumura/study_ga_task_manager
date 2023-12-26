class AddTaskRefToWorkingProcesses < ActiveRecord::Migration[6.1]
  def change
    add_reference :working_processes, :task, null: false, foreign_key: true
  end
end