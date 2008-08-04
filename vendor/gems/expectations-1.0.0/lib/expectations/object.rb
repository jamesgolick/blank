class Object
  module MochaExpectsMethod
    expects_method = Object.instance_method(:expects)
    define_method :expects do |*args|
      expects_method.bind(self).call(*args)
    end
  end
  
  module ExpectationsExpectsMethod
    def expects(*args)
      Expectations::StandardError.print "expects method called from #{caller[2].chomp(":in `__instance_exec0'")}\n"
      MochaExpectsMethod.instance_method(:expects).bind(self).call(*args)
    end
  end
  
  attr_accessor :__which_expects__
  include MochaExpectsMethod
  include ExpectationsExpectsMethod
  def expects(*args)
    (__which_expects__ || MochaExpectsMethod).instance_method(:expects).bind(self).call(*args)
  end
  
  def to
    Expectations::Recorder.new(self)
  end
  
  def not
    Not.new(self)
  end
  
  def not!
    !self
  end

  class Not
    private(*instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ })

    def initialize(subject)
      @subject = subject
    end

    def method_missing(sym, *args, &blk)
      @subject.send(sym,*args,&blk).not!
    end
  end
  
  def expectations_equal_to(other)
    self == other
  end

  unless defined? instance_exec # 1.9
    module InstanceExecMethods #:nodoc:
    end
    include InstanceExecMethods

    # Evaluate the block with the given arguments within the context of
    # this object, so self is set to the method receiver.
    #
    # From Mauricio's http://eigenclass.org/hiki/bounded+space+instance_exec
    def instance_exec(*args, &block)
      begin
        old_critical, Thread.critical = Thread.critical, true
        n = 0
        n += 1 while respond_to?(method_name = "__instance_exec#{n}")
        InstanceExecMethods.module_eval { define_method(method_name, &block) }
      ensure
        Thread.critical = old_critical
      end

      begin
        send(method_name, *args)
      ensure
        InstanceExecMethods.module_eval { remove_method(method_name) } rescue nil
      end
    end
  end
end
