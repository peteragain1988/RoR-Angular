class AddUploadsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :uploads, :json, default: '{}', null: false
    add_column :event_dates, :uploads, :json, default: '{}', null: false
  end
end
