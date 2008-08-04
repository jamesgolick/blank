require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect Expectations::Results::StateBasedFailure do
    Expectations::Expectation.new(1, nil, nil) { 2 }.execute
  end
  
  expect Expectations::Results::Fulfilled do
    Expectations::Expectation.new(1, nil, nil) { 1 }.execute
  end
  
  expect Expectations::Results::Error do
    Expectations::Expectation.new(1, nil, nil) { raise }.execute
  end
  
  expect "undefined method `no_method' for Object:Class" do
    Expectations::Expectation.new(ArgumentError, nil, nil) { Object.no_method }.execute.exception.to_s
  end
  
  expect Expectations::Results::Fulfilled do
    Expectations::Expectation.new(NoMethodError, nil, nil) { Object.no_method }.execute
  end
  
  expect nil do
    Expectations::Expectation.new(String, nil, nil) { Object.no_method }.execute.actual
  end
  
end