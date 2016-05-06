class LateDinner < ActiveRecord::Base
  # TODO put this somewhere instead of in two files (this and kitchen_controller.rb)
  DINNER_WEEKDAYS = [0, 1, 2, 3, 4]   # We only have dinners Sun-Thur

  belongs_to :brother

  def self.has_dinner_today?
    DINNER_WEEKDAYS.include? Time.zone.now.wday
  end

  def self.closed?
    Time.zone.now.hour >= 18
  end
end
