json.facility_leases @facility_leases do |lease|
    json.id lease.id
    json.company_name lease.company_name
    json.company_id lease.company_id
    json.facility_id lease.facility_id
    json.facility_name lease.facility_name
    json.start lease.lease_period.begin.to_i
    json.finish lease.lease_period.end.to_i
end