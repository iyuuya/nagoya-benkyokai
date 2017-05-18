class TweetTomorrowEventService
  def call
    @twitter = TwitterClient.new
    time = Time.now + (24 * 60 * 60) * 2
    tomorrow = time.strftime('%Y-%m-%d')
    puts "tomorrow: #{tomorrow}"

    events = Event.where('started_at < ? and tweeted_tomorrow = ?', tomorrow, false)
    events.each do |event|
      message = '[明日] ' + tweet_message(event)
      puts "tweet - #{message}"
      begin
        @twitter.tweet(message)
        event.update(tweeted_tomorrow: true)
      rescue => e
        Slack.chat_postMessage text: "#{e}\n#{message}\nevent-id:#{event.event_id}", username: 'lambda', channel: '#test-error'
        puts e
      end
    end
  end

  def tweet_message(event)
    title = ''
    event.title.split(/[[:space:]]/).each do |str|
      title += str if (title.size + str.size) < 40
    end
    title = event.title[0..40] if title.empty?

    message = ''
    if event.twitter_list_url
      twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/')
      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{title}\n\nイベントページ：#{event.event_url}\nツイッターリスト：#{twitter_list_url}"
    else
      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{title}\n\nイベントページ：#{event.event_url}"
    end

    if event.hash_tag&.present?
      message += "\n##{event.hash_tag}"
    end
    message
  end
end
