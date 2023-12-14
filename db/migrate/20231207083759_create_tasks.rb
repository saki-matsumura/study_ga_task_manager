class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :note
      t.date :deadline_on
      t.boolean :done, default: false
      t.string :image
      t.references :client, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
