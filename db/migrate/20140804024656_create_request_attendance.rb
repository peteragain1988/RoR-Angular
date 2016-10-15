class CreateRequestAttendance < ActiveRecord::Migration
  def change
    create_enum("eh_request_status", ["pending", "approved", "rejected"])

    create_table :request_attendances, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid                :released_inventory_request_id, null: false
      t.uuid                :partner_with
      t.uuid                :attendee_id,   null: false
      t.string              :attendee_type, null: false
      t.eh_request_status   :status, default: 'pending', null: false
      t.boolean             :is_host,       default: false, null: false
      t.timestamps
    end

    add_index :request_attendances, :released_inventory_request_id, using: :btree
    add_index :request_attendances, :partner_with, using: :btree
    add_index :request_attendances, :attendee_id, using: :btree
    add_index :request_attendances, :attendee_type, using: :btree
    add_index :request_attendances, :status, using: :btree
    add_index :request_attendances, :is_host
  end
end
