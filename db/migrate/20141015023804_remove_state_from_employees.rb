class RemoveStateFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :state
  end
end
