class SendLateDinnerList
  @queue = :cron

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

  DINNER_CREWS = {
    0 => :sunday_dinner,
    1 => :monday_dinner,
    2 => :tuesday_dinner,
    3 => :wednesday_dinner,
    4 => :thursday_dinner,
  }

  def self.perform
    today = Time.zone.now.to_date.wday
    @one_times = LateDinner.where(date: Time.zone.today).map(&:brother)
    @weeklys = Brother.all.select { |b| b.late_dinner_days.try(:include?, today) }.select { |b| !@one_times.include?(b) }

    message = "One-time late dinners for today:\n\n" +
              (@one_times.empty? ? 'None' : @one_times.map(&:name).join("\n")) + "\n\n" +
              "Weekly late dinners for today:\n\n" +
              (@weeklys.empty? ? 'None' : @weeklys.map(&:name).join("\n")) + "\n\n" +
              "Total number: #{@one_times.size + @weeklys.size}"

    title = "Late dinners for today"

    if current_dinner_crew[:captain].present?
      Brother.find(current_dinner_crew[:captain]).post_notification(title, message)
    end
  end

  private
    # DRY this up
    def self.kitchen_crews
      KeyValue.get('kitchen_crews_v1', Hash[KITCHEN_CREWS.keys.map { |crew| [crew, {captain: nil, members: []}] }])
    end

    def self.current_dinner_crew
      kitchen_crews[DINNER_CREWS[Time.zone.now.to_date.wday]]
    end
end