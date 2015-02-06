class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(23).minute_of_hour(20, 30, 45)  }

  def perform
    User.send_daily_digest
  end
end