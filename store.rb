require 'pstore'

class SelfieStore
  def initialize(pstore)
    @pstore = pstore
  end

  def add(tweet, approved = false)
    tweet_hash = tweet_to_hash(tweet, approved)
    @pstore.transaction do
      @pstore[:tweets] << tweet_hash
    end
  end

  def delete(tweet_id)
    @pstore.transaction do
      @pstore[:tweets].delete_if { |tweet| tweet[:id] == tweet_id }
    end
  end

  def tweets
    @pstore.transaction(true) do
      @pstore[:tweets].reverse
    end
  end

  def mark_refresh!
    @pstore.transaction do
      @pstore[:last_refresh_at] = Time.now.to_i
    end
  end

  def self.initialize_store(filename)
    store = PStore.new(filename)
    store.transaction do
      # an array of tweets
      store[:tweets] = []

      # a unix timestamp of the last time we
      # added a tweet
      store[:last_refresh_at] = 0
    end
    store
  end

  private

  def tweet_to_hash(tweet, approved)
    pic = tweet.media.find{|m| m.is_a?(Twitter::Media::Photo)}
    {
      :approved => approved,
      :id => tweet.id,
      :url => tweet.url.to_s,
      :user_name => tweet.user.screen_name,
      :user_url => tweet.user.url.to_s,
      :created_at => tweet.created_at,
      :text => tweet.text,
      :photo_url => pic.media_url_https.to_s
    }
  end
end