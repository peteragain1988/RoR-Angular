class AddConfigColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :config, :json, default: '{}', null: false
  end
end
