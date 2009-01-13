require 'metaid'

module TestDataFactory
  def data_factory(type, data)
    klass = type.to_s.classify.constantize

    define_method(:"hash_for_#{type}") do |*args|
      data.merge(args.extract_options!)
    end

    meta_def(:"hash_for_#{type}") do |*args|
      data.merge(args.extract_options!)
    end

    define_method(:"create_#{type}") do |*args|
      send("build_#{type}", args.extract_options).save!
    end

    define_method(:"build_#{type}") do |*args|
      params = send(:"hash_for_#{type}", args.extract_options!)
      returning(klass.new) do |obj|
        params.each do |k, v|
          obj.send("#{k}=", v)
        end
      end
    end
  end
end
