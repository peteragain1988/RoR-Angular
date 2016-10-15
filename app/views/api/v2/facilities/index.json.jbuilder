json.facilities @facilities do |facility|
  json.id facility.id
  json.name facility.name
  json.facility_type facility.facility_type
  json.capacity facility.capacity
  if facility.current_active_lease
    json.current_leasee_name facility.current_active_lease.company_name
  end

  if facility.name.gsub(/\D/,'')
    json.facility_number facility.name.gsub(/\D/,'').to_i
  end
end