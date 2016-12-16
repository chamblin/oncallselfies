require_relative 'twitter_with_client'
require_relative 'store'

store_file = ARGV.shift
tweet_ids = ARGV

if File.exists?(store_file)
  store = PStore.new(store_file)
else
  store = SelfieStore.initialize_store(store_file)
end

store = SelfieStore.new(store)

with_client do |client|
  tweet_ids.each do |tweet_id|
    begin
      tweet = client.status(tweet_id)
      store.add(tweet, true)
    rescue Twitter::Error::NotFound
      puts "[ERROR] No such tweet #{tweet_id}"
    rescue => e
      puts "[ERROR] #{e.message} on tweet #{tweet_id}"
    end
  end
end