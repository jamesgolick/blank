module Expectations
end

def Expectations(&block)
  Expectations::SuiteRunner.suite_eval(&block)
rescue
  Expectations::SuiteRunner.do_not_run
  raise
end

require 'mocha'
require 'mocha/standalone'
require 'singleton'
require 'benchmark'
require 'erb'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + '/expectations/object')
require File.expand_path(File.dirname(__FILE__) + '/expectations/blank_slate')
require File.expand_path(File.dirname(__FILE__) + '/expectations/recorder')
require File.expand_path(File.dirname(__FILE__) + '/expectations/delegate_recorder')
require File.expand_path(File.dirname(__FILE__) + '/expectations/recorded_expectation')
require File.expand_path(File.dirname(__FILE__) + '/expectations/state_based_recorder')
require File.expand_path(File.dirname(__FILE__) + '/expectations/reverse_result')
require File.expand_path(File.dirname(__FILE__) + '/expectations/xml_string')
require File.expand_path(File.dirname(__FILE__) + '/expectations/regexp')
require File.expand_path(File.dirname(__FILE__) + '/expectations/range')
require File.expand_path(File.dirname(__FILE__) + '/expectations/module')
require File.expand_path(File.dirname(__FILE__) + '/expectations/string')
require File.expand_path(File.dirname(__FILE__) + '/expectations/suite')
require File.expand_path(File.dirname(__FILE__) + '/expectations/suite_runner')
require File.expand_path(File.dirname(__FILE__) + '/expectations/suite_results')
require File.expand_path(File.dirname(__FILE__) + '/expectations/expectation')
require File.expand_path(File.dirname(__FILE__) + '/expectations/state_based_expectation')
require File.expand_path(File.dirname(__FILE__) + '/expectations/mock_recorder')
require File.expand_path(File.dirname(__FILE__) + '/expectations/results')
require File.expand_path(File.dirname(__FILE__) + '/expectations/standard_error')