#!/usr/bin/env ruby
#--
# Copyright 2004, 2006 by Jim Weirich (jim@weirichhouse.org).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#++

######################################################################
# BlankSlate provides an abstract base class with no predefined
# methods (except for <tt>\_\_send__</tt> and <tt>\_\_id__</tt>).
# BlankSlate is useful as a base class when writing classes that
# depend upon <tt>method_missing</tt> (e.g. dynamic proxies).
#
class Expectations::BlankSlate
  class << self

    # Hide the method named +name+ in the BlankSlate class.  Don't
    # hide +instance_eval+ or any method beginning with "__".
    def hide(name)
      if instance_methods.include?(name.to_s) and
        name !~ /^(__|instance_eval|extend|is_a?)/
        @hidden_methods ||= {}
        @hidden_methods[name.to_sym] = instance_method(name)
        undef_method name
      end
    end

    def find_hidden_method(name)
      @hidden_methods ||= {}
      @hidden_methods[name] || superclass.find_hidden_method(name)
    end

    # Redefine a previously hidden method so that it may be called on a blank
    # slate object.
    def reveal(name)
      bound_method = nil
      unbound_method = find_hidden_method(name)
      fail "Don't know how to reveal method '#{name}'" unless unbound_method
      define_method(name) do |*args|
        bound_method ||= unbound_method.bind(self)
        bound_method.call(*args)
      end
    end
  end

  instance_methods.each { |m| hide(m) }
end

######################################################################
# Since Ruby is very dynamic, methods added to the ancestors of
# BlankSlate <em>after BlankSlate is defined</em> will show up in the
# list of available BlankSlate methods.  We handle this by defining a
# hook in the Object and Kernel classes that will hide any method
# defined after BlankSlate has been loaded.
#
module Kernel
  class << self
    # Detect method additions to Kernel and remove them in the
    # BlankSlate class.
    unbound_method = method(:method_added)
    define_method :method_added do |name|
      result = unbound_method.call(name)
      return result if self != Kernel
      Expectations::BlankSlate.hide(name)
      result
    end
  end
end

######################################################################
# Same as above, except in Object.
#
class Object
  class << self
    # Detect method additions to Object and remove them in the
    # BlankSlate class.
    unbound_method = method(:method_added)
    define_method :method_added do |name|
      result = unbound_method.call(name)
      return result if self != Object
      Expectations::BlankSlate.hide(name)
      result
    end

    def find_hidden_method(name)
      nil
    end
  end
end

######################################################################
# Also, modules included into Object need to be scanned and have their
# instance methods removed from blank slate.  In theory, modules
# included into Kernel would have to be removed as well, but a
# "feature" of Ruby prevents late includes into modules from being
# exposed in the first place.
#
class Module
  unbound_method = instance_method(:append_features)
  define_method :append_features do |mod|
    result = unbound_method.bind(self).call(mod)
    return result if mod != Object
    instance_methods.each do |name|
      Expectations::BlankSlate.hide(name)
    end
    result
  end
end