class NotificationsMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "adphi-dashboard@mit.edu"

  def test_email(email)
  	mail(to: email, subject: 'Test Email')
  end

  def notification_email(email, subject, content, link)
  	@subject = subject
  	@content = content
  	@link = link

  	mail(to: email, subject: subject)
  end
end
