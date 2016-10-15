class AddDataToRequestAttendances < ActiveRecord::Migration
  def change
    add_column :request_attendances, :data, :json
  end
end
