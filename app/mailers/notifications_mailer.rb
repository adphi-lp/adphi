class NotificationsMailer < ActionMailer::Base
  default from: "notifications@adphi.house"

  def test_email(brother)
  	@brother = brother

  	mail(to: @brother.email, subject: 'Test Email')
  end
end
