module Expectations::StateBasedRecorder

  def verify
    method_stack.inject(subject) { |result, element| result.send element.first, *element.last }
  end
    
  def failure_message
    "expected #{subject} #{@message_parts.join(" ")}"
  end

  def method_stack
    @method_stack ||= []
  end
  
  def message_parts
    @message_parts ||= self.is_a?(Expectations::ReverseResult) ? [:not] : []
  end
  
  def method_missing(sym, *args)
    @message_parts << "#{sym}"
    args.each { |arg| @message_parts << arg.inspect }
    method_stack << [sym, args]
    self
  end

end