class RenameColumnInReleasedInventory < ActiveRecord::Migration
  def change
    remove_index :inventory_releases, :company_id
    rename_column :inventory_releases, :company_id, :venue_id
    add_index :inventory_releases, :venue_id
  end
end
