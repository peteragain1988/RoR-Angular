class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates, id: :uuid, default: 'uuid_generate_v1()' do |t|
      t.uuid :company_id, null: false
      t.boolean :partial, default: false
      t.boolean :editable, default: true
      t.timestamps
      t.string :name, null: false
      t.string :handler
      t.string :path
      t.string :format
      t.string :locale
      t.text :body
      t.json :data
    end

    add_index :mail_templates, :company_id
  end
end
