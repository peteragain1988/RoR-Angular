class AddClassToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :klass, :string, limit: 4
  end
end
