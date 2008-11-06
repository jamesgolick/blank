require "dm-core"
hash = YAML.load(File.new(Rails.root + "/config/database.yml"))
hash = hash[Rails.env]
hash.keys.each do |key|
  hash[key.to_sym] = hash.delete(key)
end

DataMapper.setup(:default, hash)
