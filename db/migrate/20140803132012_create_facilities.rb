class CreateFacilities < ActiveRecord::Migration
  def change
    create_table "facilities", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string "facility_type", limit: 150, null: false
      t.string "name", limit: 150, null: false
      t.uuid "company_id", null: false
      t.integer "capacity", default: 0, null: false
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
    end

    add_index "facilities", ["company_id"], name: "index_facilities_on_company_id", using: :btree
  end
end
