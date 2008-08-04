module Expectations::RecordedExpectation
  def execute
    begin
      mocha_setup
      expected.subject!
      warn_for_expects do
        instance_exec(expected.subject, &block) if block
      end
      if expected.verify! && mocha_verify
        self.extend(Expectations::Results::Fulfilled)
      else
        self.extend(Expectations::Results::StateBasedFailure)
        self.message = expected.failure_message
      end
    rescue Mocha::ExpectationError => ex
      self.extend(Expectations::Results::BehaviorBasedFailure)
      self.message = expected.mocha_error_message(ex)
    rescue Exception => ex
      self.extend(Expectations::Results::Error)
      self.exception = ex
    ensure
      mocha_teardown
    end
    self
  end

end
