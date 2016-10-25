require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup_schedule do
    require 'resque-scheduler'

    Resque.schedule = {
      send_late_dinner_list: {
        cron: "0 45 17 * * *",
        class: "SendLateDinnerList",
        queue: "cron",
        args: nil,
        description: "This job sends the current day's late dinner list to the crew captain every day. "
      }
    }
  end

  task :scheduler => :setup_schedule
end