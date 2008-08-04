require File.dirname(__FILE__) + "/../test_helper"

Expectations do

  expect "." do
    Object.new.extend(Expectations::Results::Fulfilled).char
  end

  expect "F" do
    Object.new.extend(Expectations::Results::StateBasedFailure).char
  end

  expect "F" do
    Object.new.extend(Expectations::Results::BehaviorBasedFailure).char
  end

  expect "E" do
    Object.new.extend(Expectations::Results::Error).char
  end

  expect Object.new.to.be.fulfilled? do |instance|
    instance.extend(Expectations::Results::Fulfilled)
  end

  expect Object.new.not.to.be.fulfilled? do |instance|
    instance.extend(Expectations::Results::StateBasedFailure)
  end

  expect Object.new.not.to.be.fulfilled? do |instance|
    instance.extend(Expectations::Results::BehaviorBasedFailure)
  end

  expect Object.new.not.to.be.fulfilled? do |instance|
    instance.extend(Expectations::Results::Error)
  end

  expect Object.new.not.to.be.error? do |instance|
    instance.extend(Expectations::Results::Fulfilled)
  end

  expect Object.new.not.to.be.error? do |instance|
    instance.extend(Expectations::Results::StateBasedFailure)
  end

  expect Object.new.not.to.be.error? do |instance|
    instance.extend(Expectations::Results::BehaviorBasedFailure)
  end

  expect Object.new.to.be.error? do |instance|
    instance.extend(Expectations::Results::Error)
  end

  expect Object.new.not.to.be.failure? do |instance|
    instance.extend(Expectations::Results::Fulfilled)
  end

  expect Object.new.to.be.failure? do |instance|
    instance.extend(Expectations::Results::StateBasedFailure)
  end

  expect Object.new.to.be.failure? do |instance|
    instance.extend(Expectations::Results::BehaviorBasedFailure)
  end

  expect Object.new.not.to.be.failure? do |instance|
    instance.extend(Expectations::Results::Error)
  end

end