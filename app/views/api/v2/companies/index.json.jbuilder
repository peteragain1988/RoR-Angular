json.companies @companies do |company|
  json.id company.id
  json.name company.name
  json.friendly_name company.friendly_name
  json.company_type company.company_type
  json.phone company.phone
  json.fax company.fax
  json.state company.state
  json.city company.city
  json.suburb company.suburb
  json.address1 company.address1
  json.address2 company.address2
  json.postcode company.postcode
  json.ticket_type company.ticket_type
  json.ticket_type company.notify_sms


end

# attributes :id, :friendly_name, :company_type, :name,
#            :phone, :fax, :state, :city, :suburb, :address1,
#            :address2, :postcode, :ticket_type, :notify_sms, :notify_email,
#            :guest_module