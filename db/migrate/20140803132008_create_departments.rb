class CreateDepartments < ActiveRecord::Migration
  def change
    create_table "departments", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid "manager_id", null: false
      t.uuid "company_id", null: false
      t.string "name", limit: 150, null: false
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
    end
  end
end
