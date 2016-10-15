class ChangePathTypeOnApprovalPath < ActiveRecord::Migration
  def up
    remove_column :approval_paths, :path
    add_column :approval_paths, :path, :string, array: true
  end
  def down
    remove_column :approval_paths, :path
    add_column :approval_paths, :path, :integer, array: true
  end
end
