class RemoveTicketsZipDownloadedFromInventory < ActiveRecord::Migration
  def change
    remove_column :inventory, :tickets_zip_downloaded, :json
  end
end
