class NotificationsMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "notifications@adphi.house"

  def test_email(email)
  	mail(to: email, subject: 'Test Email')
  end
end
