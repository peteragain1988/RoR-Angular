json.anz_flag false

json.events @events do |event|
  json.event_name event.name
  # lol
  json.inventory_id event.dates.first.tickets.first.inventory_id
  
  json.dates event.dates do |date|
    json.start date.event_period.begin.to_i
    json.finish date.event_period.end.to_i
    json.tickets date.tickets do |ticket|
      json.id ticket.id
      json.reference_number ticket.reference_number
      json.seat ticket.seat
      json.row ticket.row
      json.event_date_id ticket.event_date_id
      json.facility_id ticket.facility_id
      json.facility_name ticket.facility.name
      json.event_period ticket.event_date.event_period
      json.storage ticket.storage
      json.s3_file_name ticket.pdf.url
    end

  end

end