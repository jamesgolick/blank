require File.dirname(__FILE__) + "/test_helper"

Expectations do
  expect Expectations::Results::StateBasedFailure do
    suite = Expectations::Suite.new
    suite.expect(2) { 3 }
    suite.execute(Silent).expectations.first
  end
  
  expect Expectations::Results::Error do
    suite = Expectations::Suite.new
    suite.expect(ArgumentError) { Object.no_method }
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::BehaviorBasedFailure do
    suite = Expectations::Suite.new
    suite.expect Mocha::Mock.new.to.receive(:dial).with("2125551212").times(2) do |phone|
      phone.dial("2125551212")
      phone.dial("2125551212")
      phone.dial("2125551212")
    end
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::BehaviorBasedFailure do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect Mocha::Mock.new.to.receive(:dial).with("2125551212").times(2) do |phone| 
      phone.dial("2125551212")
    end
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::BehaviorBasedFailure do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(Object.to.receive(:deal)) {  }
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::Error do
    suite = Expectations::Suite.new
    suite.expect(2) { stub(:two => 2).twos }
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::Error do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(2) do
      Object.expects(:bar).returns 2
      Object.barter
    end
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::Error do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(1) do
      Object.expects(:give_me_three).with(3).returns 1
      Object.give_me_three(stub(:three=>3).threes)
    end
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::Error do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(1) do
      Object.expects(:foo)
    end
    suite.execute(Silent).expectations.first
  end

  expect Expectations::Results::Error do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(1) do
      mock(:foo => 1)
    end
    suite.execute(Silent).expectations.first
  end
  
  expect Expectations::Results::BehaviorBasedFailure do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(Object.to.receive(:foo)) do
      Object.foo
      mock(:foo => 1)
    end
    suite.execute(Silent).expectations.first
  end
  
  expect Expectations::Results::BehaviorBasedFailure do
    Expectations::StandardError.stubs(:print)
    suite = Expectations::Suite.new
    suite.expect(Object.to.receive(:foo)) do
      Object.foo
      Object.expects(:bar)
    end
    suite.execute(Silent).expectations.first
  end
  
end