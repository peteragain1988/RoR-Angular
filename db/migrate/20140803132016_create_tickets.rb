class CreateTickets < ActiveRecord::Migration
  def change
    create_table "tickets", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "event_date_id"
      t.uuid "facility_id"
      t.uuid "inventory_id"
      t.uuid "client_id"
      t.json "storage", default: {}, null: false
      t.integer "row"
      t.integer "seat"
      t.string "ticketek_id"
      t.timestamp "created_at", precision: 6
      t.timestamp "updated_at", precision: 6
      t.ehticketstatus "status", null: false
      t.column "reference_number", :serial, null: false
    end

    add_index "tickets", ["client_id"], name: "index_tickets_on_client_id", using: :btree
    add_index "tickets", ["event_date_id"], name: "index_tickets_on_event_date_id", using: :btree
    add_index "tickets", ["facility_id"], name: "index_tickets_on_facility_id", using: :btree
    add_index "tickets", ["inventory_id"], name: "index_tickets_on_inventory_id", using: :btree
    add_index "tickets", ["reference_number"], name: "index_tickets_on_reference_number", unique: true, using: :btree
    add_index "tickets", ["status"], name: "index_tickets_on_status", using: :btree
    add_index "tickets", ["ticketek_id"], name: "index_tickets_on_ticketek_id", unique: true, using: :btree
  end
end
