json.events @events do |event|
  json.id event.id
  json.name event.name
  json.event_dates event.dates do |date|
    json.id date.id
    json.start date.event_period.begin.to_i
    json.finish date.event_period.end.to_i
  end
end

json.recipients @companies do |recip|
  json.id recip.id
  json.name recip.name
  json.leases recip.facility_leases.active, :facility_name
  json.has_facility recip.facility_leases.active.length != 0
end
