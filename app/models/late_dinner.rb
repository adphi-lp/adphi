class LateDinner < ActiveRecord::Base
  belongs_to :brother

  def self.closed?
    Time.now.hour >= 18
  end
end
