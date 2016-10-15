class CreateApprovalPaths < ActiveRecord::Migration
  def change
    create_table "approval_paths", id: :uuid, default: "uuid_generate_v4()" do |t|
      t.integer "path", null: false, array: true
      t.timestamp "created_at", precision: 6, default: "now()", null: false
      t.timestamp "updated_at", precision: 6, default: "now()", null: false
    end
  end
end
