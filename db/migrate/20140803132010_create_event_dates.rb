class CreateEventDates < ActiveRecord::Migration
  def change
    create_table "event_dates", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "event_id", null: false
      t.string "status", limit: nil
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
      t.tstzrange "event_period", null: false
    end

    add_index "event_dates", ["event_id"], name: "index_event_dates_on_event_id", using: :btree
    add_index "event_dates", ["event_period"], name: "index_event_dates_on_event_period", using: :btree
  end
end
