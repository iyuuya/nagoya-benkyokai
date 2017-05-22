class UpdateEventService
  def call
    lists = TwitterClient.new.lists
    SearchEventService.new.call(ym: collect_period).each do |target_event|
      begin
        event = StoreEventService.new.call(target_event)
        UpdateTwitterListService.new.call(event, lists)
      rescue => e
        NotifyService.new.call(e, "#{event.title}")
        p e
      end
    end
    TweetNewEventService.new.call
  end

  private

  def collect_period
    now = Time.now
    day = 24 * 60 * 60
    month = 30 * day
    3.times.map { |i| (now + i * month).strftime('%Y%m') }
  end
end
