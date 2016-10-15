class CreateConfirmedOptions < ActiveRecord::Migration
  def change
    create_table "confirmed_options", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "client_id", null: false
      t.text "notes"
      t.json "selection"
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.uuid "inventory_id", null: false
      t.text "host_details"
      t.json "guests", default: [], null: false
      t.boolean "is_attending", default: false, null: false
      t.json "data", default: {}, null: false
      t.timestamp "deleted_at", precision: 6
    end

    add_index "confirmed_options", ["client_id"], name: "index_confirmed_options_on_client_id", using: :btree
    add_index "confirmed_options", ["deleted_at"], name: "index_confirmed_options_on_deleted_at", using: :btree
    add_index "confirmed_options", ["inventory_id"], name: "index_confirmed_options_on_inventory_id", using: :btree
  end
end
