class MailgunMailer < ActionMailer::Base
  default from: "cs@turnkeyhospitality.com.au"
  include Roadie::Rails::Automatic

  prepend_view_path MailTemplate::Resolver.instance


  def welcome_user_notification(employee)
    if %w(development test).include?(Rails.env)
      @confirm_url = "http://localhost:3000/confirm/#{employee.reset_password_token}"
      @login_url = 'http://localhost:3000/'
    else
      @confirm_url = "https://venue.eventhub.com.au/confirm/#{employee.reset_password_token}"
      @login_url = 'https://venue.eventhub.com.au/'
    end

    mail(to: employee.email, subject: 'Welcome to Eventhub')
  end

  def report_incorrect_profile_data(manager, employee, comment)
    @comment = comment
    @employee = employee
    @manager = manager
    mail to: @manager.email, subject: 'Incorrect profile data reported'
  end

  def reset_password_notifcation(token, employee, domain)
    mail to: "#{employee.email}"
  end

  def reset_password_request(token, employee, request)
    @token, @employee, @request = token, employee, request

    mail to: "#{employee.email}"

  end

  #layout 'mailers/allphones-db'
  layout 'mailers/allphones'

  def option_confirm_notification(option)
    @option = option
    if Rails.env.production?

      if @option.company.id == 'd027778e-8a0f-42a0-a32c-bbf715ad71b1'
        mail to: @option.company.manager.email,
             bcc: %w(scott@vendormax.com.au david.culina@gmail.com rob@turnkeyhospitality.com.au),
             subject: "Your Event Confirmation TESTING CLIENT- #{@option.event.name}"
      else
        mail to: @option.company.manager.email,
             bcc: %w(scott@vendormax.com.au david.culina@gmail.com kmacintosh@allphonesarena.com.au pip@turnkeymanagement.com.au),
             subject: "Your Event Confirmation - #{@option.event.name}"
      end
    else
      mail to: 'david.culina@gmail.com',
           subject: "DEVELOPMENT - #{@option.event.name}"
    end

  end


  def notification_mailer(options)
    # Because it caches or some crap
    @mail_template = MailTemplate.find(options['mail_template_id']).reload

    @subject = Liquid::Template.parse(@mail_template.subject).render(options)

    options['event_promoter'] = nil if options['event_promoter'].blank?


    override_subject, override_recipient = false,false
    # In development mode the emails come to me
    override_recipient = 'david.culina@gmail.com' if Rails.env.development?

    # In staging the emails go to everyone bar the actual recipient
    override_recipient = %w(scott@vendormax.com.au david.culina@gmail.com kmacintosh@allphonesarena.com.au pip@turnkeymanagement.com.au) if Rails.env.staging?

    # We append the environment name to the subject unless we are in production
    override_subject = "#{Rails.env.upcase} - #{@subject}" unless Rails.env.production?

    bcc = @mail_template.bcc ? @mail_template.bcc.split(',') : ['']
    # bcc.push 'notify@turnkeyhospitality.com.au' unless Rails.env.development?

    reply_to = @mail_template.reply_to ? @mail_template.reply_to : 'cs@turnkeyhospitality.com.au'

    mail(
        to: override_recipient || options['recipient']['email'],
        subject: override_subject || @subject,
        bcc: bcc,
        reply_to: reply_to
    ) do |format|
      format.html { render @mail_template.path, locals: options  }
    end

  end

end
