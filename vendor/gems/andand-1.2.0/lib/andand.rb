$:.unshift File.dirname(__FILE__)

module AndAnd
  
  module ObjectGoodies
    
    def andand (p = nil)
      if self
        if block_given?
          yield(self)
        elsif p
          p.to_proc.call(self)
        else
          self
        end
      else
        if block_given? or p
          self
        else
          MockReturningMe.new(self)
        end
      end 
    end
    
    def me (p = nil)
      if block_given?
        yield(self)
        self
      elsif p
        p.to_proc.call(self)
        self
      else
        ProxyReturningMe.new(self)
      end
    end
    
    alias :tap :me
    
    def dont (p = nil)
      if block_given?
        self
      elsif p
        self
      else
        MockReturningMe.new(self)
      end
    end
    
  end
  
end

class Object
  include AndAnd::ObjectGoodies
end

module AndAnd
  
  class BlankSlate
    instance_methods.reject { |m| m =~ /^__/ }.each { |m| undef_method m }
    def initialize(me)
      @me = me
    end
  end
  
  class MockReturningMe < BlankSlate
    def method_missing(*args)
      @me
    end
  end
  
  class ProxyReturningMe < BlankSlate
    def method_missing(sym, *args, &block)
      @me.__send__(sym, *args, &block)
      @me
    end
  end
  
end