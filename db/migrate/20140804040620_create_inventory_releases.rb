class CreateInventoryReleases < ActiveRecord::Migration
  def change
    create_table :inventory_releases, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid      :inventory_id, null: false
      t.uuid      :client_id, null: false
      t.uuid      :company_id, null: false
      t.uuid      :department_id
      t.integer   :total_released_count, null: false
      t.integer   :total_open_count, null: false
      t.integer   :total_approved_count, default: 0, null: false
      t.integer   :total_requested_count, default: 0, null: false
      t.string    :event_class
      t.boolean   :catering_included, default: false, null: false
      t.money     :catering_value
      t.json      :data, default: '{}', null: false

      t.timestamps
    end

    add_index :inventory_releases, :inventory_id, using: :btree
    add_index :inventory_releases, :client_id, using: :btree
    add_index :inventory_releases, :company_id, using: :btree
    add_index :inventory_releases, :department_id, using: :btree

  end
end
