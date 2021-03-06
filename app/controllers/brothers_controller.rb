class BrothersController < ApplicationController
  load_and_authorize_resource

  include PositionConstants

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
          house_debt: bs.select { |x| x.house_debt? } [0] || Brother.find(b).balance(:house_debt),
          social: bs.select { |x| x.social? } [0] || Brother.find(b).balance(:social)
        }
      ]
    end

    @presences = Attendence.all.group_by { |a| a.brother_id }.hmap do |b, as|
      [b, as.select { |a| a.present? || a.tardy? }.size]
    end
  end

  def officers
    @officers = {}

    POSITIONS.each do |p|
      begin
        @officers[p] = Brother.officer(p)
      rescue ActiveRecord::RecordNotFound
        @officers[p] = nil
      end
    end
  end

  def appoint
    position = params[:position].to_sym

    Brother.all.each do |b|
      if b.positions.include? position
        b.positions.delete(position)
        b.save!
      end
    end

    if params[:brother_id].to_i != 0
      brother = Brother.find(params[:brother_id])
      brother.positions << position
      brother.save!

      redirect_to officers_brothers_path, flash: {success: "You have successfully appointed #{brother.display_name} to the office of \"#{POSITION_NAMES[position]}\". "}
    else
      redirect_to officers_brothers_path, flash: {success: "You have successfully set the office of \"#{POSITION_NAMES[position]}\" to be vacant. "}
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
