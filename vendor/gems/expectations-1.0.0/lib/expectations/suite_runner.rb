class Expectations::SuiteRunner
  include Singleton
  attr_accessor :suite
  
  def initialize
    self.suite = Expectations::Suite.new
    at_exit do
      exit 1 unless suite.execute.succeeded?
    end
  end
  
  def self.do_not_run
    self.instance.suite.do_not_run
  end
  
  def self.suite_eval(&block)
    self.instance.suite.instance_eval(&block)
  end
end
