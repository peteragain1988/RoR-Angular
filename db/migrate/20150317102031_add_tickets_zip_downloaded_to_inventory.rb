class AddTicketsZipDownloadedToInventory < ActiveRecord::Migration
  def change
    add_column :inventory, :tickets_zip_downloaded, :json, default: '{}', null: false
  end
end
