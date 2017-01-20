require_relative 'store'

store_file = ARGV.shift

unless File.exists?(store_file)
  SelfieStore.initialize_store(store_file)
end

store = PStore.new(store_file)
store.transaction do
  store[:tweets] = store[:tweets].sort_by{|t| t[:created_at]}
end