class Profile < ActiveRecord::Base
  belongs_to :employee
  
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    [first_name,last_name].join ' '
  end
end
