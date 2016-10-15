class AddDataToEventDate < ActiveRecord::Migration
  def change
    add_column :event_dates, :data, :json, default: '{}', null: false
  end
end
