require_relative 'store'
require_relative 'twitter_with_client'

store = SelfieStore.new(PStore.new("selfies.pstore"))

with_streaming_client do |client|
  client.filter(:track => "#oncallselfie") do |tweet|
    if tweet.media? &&
       !(tweet.retweeted_status? || t.retweeted_tweet?) &&
       tweet.media.find{|m| m.is_a?(Twitter::Media::Photo)}
      puts "#{Time.now} STORE: (tweet.id) @#{tweet.user.screen_name}: #{tweet.text}"
      store.add(tweet, true)
    else
      puts "#{Time.now} SKIP: (tweet.id) @#{tweet.user.screen_name}: #{tweet.text}"
    end
    store.mark_refresh!
  end
end