module TestDataFactory
  def data_factory(type, data)
    klass = type.to_s.classify.constantize

    define_method(:"hash_for_#{type}") do |*args|
      data.merge(args.extract_options!)
    end

    define_method(:"create_#{type}") do |*args|
      klass.create!(send(:"hash_for_#{type}", args.extract_options!))
    end

    define_method(:"build_#{type}") do |*args|
      klass.new(send(:"hash_for_#{type}", args.extract_options!))
    end
  end
end
