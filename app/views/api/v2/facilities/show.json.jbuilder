json.facility do
  json.id @facility.id
  json.company_id @facility.company_id
  json.name @facility.name
  json.capacity @facility.capacity
  json.facility_type @facility.facility_type
  json.created_at @facility.created_at
  json.updated_at @facility.updated_at

  json.facility_leases_attributes @facility.facility_leases do |lease|
    json.id lease.id
    json.facility_id lease.facility_id
    json.company_id lease.company_id
    json.company_name lease.company_name
    json.is_enabled lease.is_enabled
    json.start lease.lease_period.begin.to_i
    json.finish lease.lease_period.end.to_i
  end
end