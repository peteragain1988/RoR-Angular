class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests, id: :uuid, default: 'uuid_generate_v1()' do |t|
      t.uuid :company_id
      t.string :encrypted_email
      t.string :encrypted_first_name
      t.string :encrypted_last_name
      t.json :data
      t.timestamps
    end

    add_index :guests, :company_id
  end
end
