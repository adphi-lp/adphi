web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: bundle exec rake environment resque:work QUEUE='*'
resque_scheduler: bundle exec rake environment resque:scheduler