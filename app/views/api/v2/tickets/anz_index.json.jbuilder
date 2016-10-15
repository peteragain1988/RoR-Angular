json.anz_flag true

if @user_email
  json.email @user_email
end
  
json.events @events do |event|
  json.event_name event.name
  # lol
  json.inventory_id event.dates.first.tickets.first.inventory_id
  
  if @facility_name !=""
  	json.facility_id event.dates.first.tickets.first.facility_id
  end
  
  if event.dates.first.tickets.first.inventory.tickets_zip_downloaded && @user_id
  	json.download_status event.dates.first.tickets.first.inventory.tickets_zip_downloaded.include?@user_id
  else
  	json.download_status false
  end
  
  if @user_id
  	json.client_id @user_id
  end
  
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