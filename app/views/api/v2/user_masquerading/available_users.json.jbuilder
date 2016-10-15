json.array! @employees do |emp|
  json.id emp.id
  json.full_name emp.full_name
  json.email emp.email
  json.company_name emp.company_name
end