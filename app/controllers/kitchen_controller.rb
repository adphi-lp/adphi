class KitchenController < ApplicationController
  DINNER_WEEKDAYS = [0, 1, 2, 3, 4]   # We only have dinners Sun-Thur

  def roster
    @crews = dinner_crews
    @assigned_brothers = @crews.values.flatten
    @unassigned_brothers = Brother.all.to_a.select { |b| !@assigned_brothers.include? b.id }
  end

  def remove
    @brother = Brother.find(params[:brother_id])
    @crews = dinner_crews

    DINNER_WEEKDAYS.each do |wd|
      @crews[wd] = @crews[wd].select { |b| b != @brother.id }
    end

    save_dinner_crews(@crews)

    redirect_to kitchen_roster_path, flash: {success: "You have successfully removed #{@brother.name} from his kitchen crew. "}
  end

  def add
    brother_id = params[:brother_id].to_i
    wday = params[:wday].to_i

    @brother = Brother.find(brother_id)
    @crews = dinner_crews
    @crews[wday] << brother_id unless @crews[wday].include? brother_id

    save_dinner_crews(@crews)

    redirect_to kitchen_roster_path, flash: {success: "You have successfully added #{@brother.name} to the #{Date::DAYNAMES[wday]} dinner crew. "}
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
    def dinner_crews
      KeyValue.get('dinner_crews', Hash[DINNER_WEEKDAYS.map { |wd| [wd, []] }])
    end

    def save_dinner_crews(crews)
      KeyValue.set('dinner_crews', crews)
    end
end
