json.facility_lease do
  json.id @facility_lease.id
  json.company_name @facility_lease.company_name
  json.company_id @facility_lease.company_id
  json.is_enabled @facility_lease.is_enabled
  json.facility_id @facility_lease.facility_id
  json.facility_name @facility_lease.facility_name
  json.start @facility_lease.lease_period.begin.to_i
  json.finish @facility_lease.lease_period.end.to_i
end