class CreateInventory < ActiveRecord::Migration
  def change
    create_table "inventory", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "event_date_id", null: false
      t.uuid "facility_id", null: false
      t.uuid "company_id", null: false
      t.uuid "client_id", null: false
      t.inventorystatus "status"
      t.integer "total", default: 0, null: false
      t.integer "remaining", default: 0, null: false
      t.integer "taken", default: 0, null: false
      t.integer "reserved", default: 0, null: false
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
      t.json "options", default: {}, null: false
    end

    add_index "inventory", ["client_id"], name: "index_inventory_on_client_id", using: :btree
    add_index "inventory", ["company_id"], name: "index_inventory_on_company_id", using: :btree
    add_index "inventory", ["event_date_id"], name: "index_inventory_on_event_date_id", using: :btree
    add_index "inventory", ["facility_id"], name: "index_inventory_on_facility_id", using: :btree
    add_index "inventory", ["status"], name: "index_inventory_on_status", using: :btree
  end
end
