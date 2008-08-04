require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect mock.to.receive(:instance_eval) do |suite|
    Expectations::SuiteRunner.stubs(:instance).returns stub(:suite => suite)
    Expectations::SuiteRunner.suite_eval {}
  end

  expect mock.to.receive(:do_not_run) do |suite|
    Expectations::SuiteRunner.stubs(:instance).returns stub(:suite => suite)
    Expectations::SuiteRunner.do_not_run
  end
end