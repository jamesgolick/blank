require "dm-core"
hash = YAML.load(File.new(Rails.root + "/config/database.yml"))
DataMapper.setup(:default, hash[Rails.env])
