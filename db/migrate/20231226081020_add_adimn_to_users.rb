class AddAdimnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :roll, :integer, default: 0
  end
end
