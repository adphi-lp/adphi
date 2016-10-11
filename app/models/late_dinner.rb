class LateDinner < ActiveRecord::Base
  # TODO put this somewhere instead of in two files (this and kitchen_controller.rb)
  DINNER_WEEKDAYS = [0, 1, 2, 3, 4]   # We only have dinners Sun-Thur
  LATE_DINNER_CUTOFF = 17.hours + 40.minutes

  belongs_to :brother

  def self.has_dinner_today?
    DINNER_WEEKDAYS.include? Time.zone.now.wday
  end

  def self.closed?
    self.time_since_today >= LATE_DINNER_CUTOFF
  end

  def self.time_until_close
    LATE_DINNER_CUTOFF - self.time_since_today
  end

  private
    def self.time_since_today
      Time.zone.now - Time.zone.now.at_beginning_of_day
    end
end
