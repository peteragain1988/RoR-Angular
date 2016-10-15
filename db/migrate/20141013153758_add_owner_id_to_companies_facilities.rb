class AddOwnerIdToCompaniesFacilities < ActiveRecord::Migration
  def up
    add_column :companies_facilities, :owner_id, :uuid, index: true

    FacilityLease.includes(:facility).each do |f|
      f.update_attribute :owner_id, f.facility.company_id
    end

  end
end
