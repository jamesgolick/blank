class Expectations::Recorder < Expectations::BlankSlate
  
  attr_reader :subject
  def initialize(subject)
    @subject = subject
  end
  
  def receive(meth)
    extend Expectations::MockRecorder
    receive!(meth)
    self
  end
  
  def have
    extend Expectations::StateBasedRecorder
    message_parts << "to have"
    self
  end
  
  def be
    extend Expectations::StateBasedRecorder
    message_parts << "to be"
    self
  end
  
  def delegate(method)
    extend Expectations::DelegateRecorder
    delegate!(method)
    self
  end
  
  def subject!
    subject
  end

  def not!
    extend Expectations::ReverseResult
  end
  
  def verify!
    verify
  end
  
end