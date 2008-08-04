module Expectations::DelegateRecorder
  attr_accessor :delegation_result
  
  def delegate!(meth)
    @subject_mock = Mocha::Mock.new
    @meth = meth
    @subject_mock.expects(meth).returns(:a_delegated_return_value)
    recorder = self
    mod = Module.new do
      define_method meth do |*args|
        recorder.delegation_result = super
      end
    end
    subject.extend mod
  end
  
  def to(receiver)
    @receiver = receiver
    self
  end
  
  def subject!
    subject.stubs(@receiver).returns(@subject_mock)
    subject
  end
  
  def verify
    @subject_mock.verify
    :a_delegated_return_value == delegation_result
  end
  
  def failure_message
    "expected #{subject}.#{@meth} to return the value of #{subject}.#{@receiver}.#{@meth}; however, #{subject}.#{@meth} returned #{delegation_result}"
  end
  
  def mocha_error_message(ex)
    "expected #{subject} to delegate #{@meth} to #{@receiver}; however, #{subject}.#{@meth} was never called"
  end
  
end