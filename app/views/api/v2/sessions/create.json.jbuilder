json.user do
  json.id @user.id
  json.email @user.email
  json.full_name @user.full_name
  json.created_at @user.created_at.to_i
  json.updated_at @user.updated_at.to_i
  json.permissions @user.permissions
  json.company @user.company, :company_type, :name, :id
end
#
#
# class EmployeeSerializer < ActiveModel::Serializer
#   attributes :id, :email, :permissions, :department_id, :state
#
#   has_one :profile
#   has_one :company
# end
