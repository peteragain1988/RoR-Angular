class AddOtpKeyToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :otp_secret, :string, limit: 16
  end
end
