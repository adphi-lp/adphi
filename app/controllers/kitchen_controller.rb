class KitchenController < ApplicationController
  DINNER_WEEKDAYS = [0, 1, 2, 3, 4]   # We only have dinners Sun-Thur
  KITCHEN_CREWS = {
    sunday_supersquad:  'Sunday Supersquad',
    sunday_dinner:      'Sunday Dinner',
    monday_lunch:       'Monday Lunch',
    monday_dinner:      'Monday Dinner',
    tuesday_lunch:      'Tuesday Lunch',
    tuesday_dinner:     'Tuesday Dinner',
    wednesday_lunch:    'Wednesday Lunch',
    wednesday_dinner:   'Wednesday Dinner',
    thursday_lunch:     'Thursday Lunch',
    thursday_dinner:    'Thursday Dinner',
    friday_cleanup:     'Friday Cleanup',
  }

  CREWS_WITH_CAPTAIN = [:sunday_supersquad, :sunday_dinner, :monday_dinner, :tuesday_dinner, :wednesday_dinner, :thursday_dinner]

  def roster
    @crews = kitchen_crews
    @assigned_brothers = @crews.values.flatten
    @unassigned_brothers = Brother.all.to_a.select { |b| !@assigned_brothers.include? b.id }
  end

  def remove
    @brother = Brother.find(params[:brother_id])
    @crews = kitchen_crews

    KITCHEN_CREWS.keys.each do |crew|
      @crews[crew][:members].select! { |b| b != @brother.id }
      @crews[crew][:captain] = nil if @crews[crew][:captain] == @brother.id
    end

    save_kitchen_crews(@crews)

    redirect_to kitchen_roster_path, flash: {success: "You have successfully removed #{@brother.name} from his kitchen crew. "}
  end

  def add
    brother_id = params[:brother_id].to_i
    crew = params[:crew].to_sym
    captain = !!(params[:commit] =~ /Captain/)

    @brother = Brother.find(brother_id)
    @crews = kitchen_crews
    @crews[crew][:members] << brother_id unless @crews[crew][:members].include? brother_id
    @crews[crew][:captain] = brother_id if captain

    save_kitchen_crews(@crews)

    redirect_to kitchen_roster_path, flash: {success: "You have successfully added #{@brother.name} to the #{KITCHEN_CREWS[crew]} dinner crew. " + (captain ? "He is also made the captain. " : "")}
  end

  def late_dinner
  end

  def current_late_dinners
  end

  def toggle_weekly_late_dinner
    wday = params[:wday].to_i
    brother_id = params[:brother_id]
    brother = brother_id.present? ? Brother.find(brother_id) : current_brother
    reason = params[:reason]

    brother.late_dinner_days ||= []

    if brother.late_dinner_days.include? wday
      brother.late_dinner_days.delete(wday)
      verb = 'removed requests for'
    else
      brother.late_dinner_days << wday
      verb = 'requested'

      dayname = Date::DAYNAMES[wday]

      Brother.officer(:kitchen_manager).post_notification(
        "#{brother.name} has requested weekly late dinners for every #{dayname}. ",
        [
          "#{brother.name} has requested weekly late dinners for every #{dayname}. ",
          "The reason given is: #{reason}",
          "Use the link below to manage weekly late dinners. "
        ].join("\n"),
        kitchen_weekly_late_dinners_path
      )
    end

    brother.save!

    suffix = (current_brother.id == brother.id ? '' : " for #{brother.name}")

    redirect_to :back, flash: {success: "You have successfully #{verb} late dinners for every #{Date::DAYNAMES[wday]}#{suffix}. "}
  end

  def request_one_time_late_dinner
    if LateDinner.closed?
      redirect_to kitchen_late_dinner_path, flash: {alert: "Late dinner requests for today have already closed. "}
    else
      current_brother.late_dinners.create(date: Time.zone.today)
      redirect_to kitchen_late_dinner_path, flash: {success: "You have successfully requested late dinner for today. "}
    end
  end

  def weekly_late_dinners
    authorize! :manage_weekly_late_dinners, KeyValue
  end

  private
    def kitchen_crews
      KeyValue.get('kitchen_crews_v1', Hash[KITCHEN_CREWS.keys.map { |crew| [crew, {captain: nil, members: []}] }])
    end

    def save_kitchen_crews(crews)
      KeyValue.set('kitchen_crews_v1', crews)
    end
end
