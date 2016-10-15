json.company do
  json.id @company.id
  json.company_id @company.company_id
  json.name @company.name
  json.capacity @company.capacity
  json.facility_type @company.facility_type
  json.created_at @company.created_at
  json.updated_at @company.updated_at

  json.facility_leases_attributes @company.facility_leases do |lease|
    json.id lease.id
    json.facility_id lease.facility_id
    json.facility_name lease.facility_name
    json.company_id lease.company_id
    json.company_name lease.company_name
    json.is_enabled lease.is_enabled
    json.start lease.lease_period.begin.to_i
    json.finish lease.lease_period.end.to_i
  end
end