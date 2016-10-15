class AddStateToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :state, :string
  end
end
