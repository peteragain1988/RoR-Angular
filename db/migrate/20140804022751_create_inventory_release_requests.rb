class CreateInventoryReleaseRequests < ActiveRecord::Migration
  def change
    create_table :released_inventory_requests, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid :inventory_release_id, null: false
      t.uuid :requester_id,         null: false
      t.uuid :approval_path_id,     null: false

      t.uuid :last_approver_id
      t.uuid :next_approver_id
      t.uuid :strategic_reason_id, null: false

      t.integer :total_attendee_count,    null: false
      t.integer :approved_attendee_count, null: false, default: 0
      t.integer :rejected_attendee_count, null: false, default: 0

      t.json :data, default: '{}', null: false
      t.date :next_reminder_date
      t.timestamps
    end

    add_index :released_inventory_requests,  :inventory_release_id,  using: :btree
    add_index :released_inventory_requests,  :strategic_reason_id,   using: :btree
    add_index :released_inventory_requests,  :approval_path_id,      using: :btree
    add_index :released_inventory_requests,  :last_approver_id,      using: :btree
    add_index :released_inventory_requests,  :next_approver_id,      using: :btree
    add_index :released_inventory_requests,  :requester_id,          using: :btree

  end
end