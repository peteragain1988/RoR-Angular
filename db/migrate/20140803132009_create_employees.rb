class CreateEmployees < ActiveRecord::Migration
  def change
    create_table "employees", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "company_id"
      t.uuid "department_id"
      t.uuid "approval_path_id"
      t.string "email", limit: 175, null: false
      t.json "permissions", default: {}, null: false
      t.string "password_digest", limit: 60
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
    end

    add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
    add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  end
end
