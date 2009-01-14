module HelperMacros
  def self.included(klass)
    klass.class_eval do 
      extend  ClassMethods
      include InstanceMethods
    end
  end

  module InstanceMethods
  end

  module ClassMethods
    def on(method, action, params={})
      message = "on #{method.to_s.upcase} to #{action.to_sym}"
      message << " #{params.inspect}" unless params.empty?
      context(message) do
        setup do
          real_params = params.inject({}) do |memo, (k, v)|
            memo[k] = v.respond_to?(:call) ? instance_eval(&v) : v
            memo
          end
          send(method, action, real_params)
        end

        yield
      end
    end
  end
end

Test::Unit::TestCase.send(:include, HelperMacros)
