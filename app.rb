require 'sinatra'
require_relative 'store'

get '/' do
  store = SelfieStore.new(PStore.new("selfies.pstore"))
  tweet_hashes = store.tweets
  erb :index, { :locals => { :tweets => tweet_hashes } }
end
