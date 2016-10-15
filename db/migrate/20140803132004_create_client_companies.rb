class CreateClientCompanies < ActiveRecord::Migration
  def change
    create_table "clients_companies", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "company_id", null: false
      t.uuid "client_id", null: false
      t.timestamp "created_at", precision: 6, default: "now()", null: false
    end

    add_index "clients_companies", ["client_id"], name: "index_clients_companies_on_client_id", using: :btree
    add_index "clients_companies", ["company_id"], name: "index_clients_companies_on_company_id", using: :btree
  end
end
