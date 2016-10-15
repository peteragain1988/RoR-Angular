class CreateEvents < ActiveRecord::Migration
  def change
    create_table "events", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string "name", null: false
      t.text "description"
      t.string "event_type", limit: nil
      t.string "category", limit: nil
      t.uuid "company_id"
      t.eventstatus "status", null: false
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
      t.json "data", default: {}, null: false
    end

    add_index "events", ["company_id"], name: "index_events_on_company_id", using: :btree
  end
end
