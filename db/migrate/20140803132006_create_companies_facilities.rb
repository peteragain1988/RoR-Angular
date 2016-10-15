class CreateCompaniesFacilities < ActiveRecord::Migration
  def change
    create_table "companies_facilities", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "company_id", null: false
      t.uuid "facility_id", null: false
      t.tstzrange "lease_period", null: false
      t.boolean "is_enabled", default: true, null: false
    end

    add_index "companies_facilities", ["company_id"], name: "index_companies_facilities_on_company_id", using: :btree
    add_index "companies_facilities", ["facility_id"], name: "index_companies_facilities_on_facility_id", using: :btree
    add_index "companies_facilities", ["lease_period"], name: "index_companies_facilities_on_lease_period", using: :btree
  end
end
