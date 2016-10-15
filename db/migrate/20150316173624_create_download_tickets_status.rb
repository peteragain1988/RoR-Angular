class CreateDownloadTicketsStatus < ActiveRecord::Migration
  def change
    create_table :download_tickets_statuses do |t|
      t.uuid :inventory_id
      t.uuid :client_id
      t.string :status
    end
  end
end
