class Expectations::Expectation
  include Mocha::Standalone
  attr_accessor :expected, :block, :file, :line, :actual
  
  def initialize(expected, file, line, &block)
    self.expected, self.block = expected, block
    self.file, self.line = file, line.to_i
    case
      when expected.is_a?(Expectations::Recorder) then extend(Expectations::RecordedExpectation)
      else extend(Expectations::StateBasedExpectation)
    end
  end
  
  def mock(*args)
    Expectations::StandardError.print "mock method called from #{caller.first.chomp(":in `__instance_exec0'")}\n"
    super
  end
  
  def warn_for_expects
    Object.__which_expects__ = ExpectationsExpectsMethod
    yield
  ensure
    Object.__which_expects__ = MochaExpectsMethod
  end
end