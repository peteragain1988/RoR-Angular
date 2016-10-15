class CreateCompanies < ActiveRecord::Migration
  def change
    create_table "companies", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "manager_id"
      t.string "name", limit: 150, null: false
      t.string "friendly_name", limit: 150, null: false
      t.string "company_type", limit: nil, default: "company"
      t.json "address", default: {}
      t.json "contact", default: {}
      t.json "modules", default: {}
      t.json "notifications", default: {}
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
      t.json "config", default: {}
    end

    add_index "companies", ["manager_id"], name: "index_companies_on_manager_id", using: :btree
  end
end
