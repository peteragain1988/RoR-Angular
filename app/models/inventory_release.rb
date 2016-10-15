class InventoryRelease < ActiveRecord::Base
  belongs_to  :inventory
  belongs_to  :department
  belongs_to  :client, class_name: 'Company'
  belongs_to  :venue, class_name: 'Company'
  has_many    :released_inventory_requests
end