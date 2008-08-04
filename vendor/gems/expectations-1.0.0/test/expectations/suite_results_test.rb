require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect 1 do
    results = Expectations::SuiteResults.new(Silent)
    results << Object.new.extend(Expectations::Results::Fulfilled)
    results.fulfilled.size
  end

  expect 0 do
    results = Expectations::SuiteResults.new(Silent)
    results << Object.new.extend(Expectations::Results::Fulfilled)
    results.errors.size
  end
  
  expect Expectations::SuiteResults.new(Silent).not.to.have.succeeded? do |results|
    results << Object.new.extend(Expectations::Results::StateBasedFailure)
    results << Object.new.extend(Expectations::Results::Fulfilled)
  end

  expect Expectations::SuiteResults.new(Silent).not.to.have.succeeded? do |results|
    results << Object.new.extend(Expectations::Results::BehaviorBasedFailure)
    results << Object.new.extend(Expectations::Results::Fulfilled)
  end
  
  expect Expectations::SuiteResults.new(Silent).to.have.succeeded? do |results|
    results << Object.new.extend(Expectations::Results::Fulfilled)
    results << Object.new.extend(Expectations::Results::Fulfilled)
  end
  
end