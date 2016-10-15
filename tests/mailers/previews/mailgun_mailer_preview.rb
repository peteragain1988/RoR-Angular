class MailgunMailerPreview < ActionMailer::Preview

  def option_confirm_notification
    option = ConfirmedInventoryOption.order('created_at ASC').last
    MailgunMailer.option_confirm_notification(option)
  end

  def test
    MailgunMailer.notification_mailer({:mail_template_id =>'325a1e9c-4b87-11e4-aa42-7831c1d0119c'})
  end

  def welcome_user_notification
    employee = Employee.first
    MailgunMailer.welcome_user_notification employee
  end
end