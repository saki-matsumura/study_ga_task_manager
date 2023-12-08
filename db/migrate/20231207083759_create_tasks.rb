class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :note
      t.date :deadline_on
      t.boolean :done, default: false
      t.references :client, null: false, foreign_key: true
      t.references :working_process, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
