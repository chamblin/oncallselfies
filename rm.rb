require_relative 'store'

store_file = ARGV.shift
ids = ARGV

if File.exists?(store_file)
  store = PStore.new(store_file)
else
  store = SelfieStore.initialize_store(store_file)
end

store = SelfieStore.new(store)
ids.each do |id|
  store.delete(id.to_i)
end