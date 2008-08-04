module Expectations::MockRecorder
  
  def receive!(method)
    method_stack << [:expects, [method]]
    self
  end
  
  def method_stack
    @method_stack ||= []
  end
  
  def method_missing(sym, *args)
    super if method_stack.empty?
    method_stack << [sym, args]
    self
  end
  
  def subject!
    method_stack.inject(subject) { |result, element| result.send element.first, *element.last }
    subject
  end
  
  def verify
    subject.verify
  end
  
  def mocha_error_message(ex)
    ex.message
  end
  
end