class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :email, :permissions, :department_id, :state

  has_one :profile
  has_one :company
end
