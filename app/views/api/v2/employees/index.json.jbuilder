json.employees @employees do |employee|
  json.id employee.id
  json.email employee.email
  json.state employee.state
  json.position employee.position
  json.cost_center employee.cost_center
  json.bi_access employee.bi_access
  json.department_id employee.department_id
  json.department_name employee.department_name
  json.permissions employee.permissions
  json.profile_attributes employee.profile
  json.company employee.company
  json.full_name employee.full_name

  if employee.approval_path.present?
    json.first_manager employee.approval_path.path[0]
    json.second_manager employee.approval_path.path[1]
    json.third_manager employee.approval_path.path[2]
  end
end

# attributes :id, :email, :permissions, :department_id, :state
#
# has_one :profile
# has_one :company