class BrothersController < ApplicationController
  load_and_authorize_resource

  def show
    @logs = @brother.shortlogs.order('created_at DESC').map { |x| x.to_summary_entry }.compact
  end

  def index
    @brothers = Brother.current
    @balances = Balance.all.group_by { |x| x.brother_id }.hmap do |b, bs|
      [
        b,
        {
          kitchen: bs.select { |x| x.kitchen? } [0] || Brother.find(b).balance(:kitchen),
          house: bs.select { |x| x.house? } [0] || Brother.find(b).balance(:house),
          social: bs.select { |x| x.social? } [0] || Brother.find(b).balance(:social)
        }
      ]
    end

    @presences = Attendence.all.group_by { |a| a.brother_id }.hmap do |b, as|
      [b, as.select { |a| a.present? || a.tardy? }.size]
    end
  end

  # Send a test email to the brother
  def test_email
    @brother.post_notification(
      "Email testing. ",
      "This email serves solely to ascertain that ADP Dashboard emails can reach your email address. ",
      root_url
    )

    redirect_to root_url, flash: { notice: "Test email sent to #{@brother.email}. " }
  end
end
