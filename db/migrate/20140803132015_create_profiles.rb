class CreateProfiles < ActiveRecord::Migration
  def change
    create_table "profiles", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string "first_name", limit: 50, null: false
      t.string "last_name", limit: 50, null: false
      t.string "sex", limit: nil, null: false
      t.date "dob"
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
      t.uuid "employee_id"
    end

    add_index "profiles", ["employee_id"], name: "index_profiles_on_employee_id", using: :btree
  end
end
