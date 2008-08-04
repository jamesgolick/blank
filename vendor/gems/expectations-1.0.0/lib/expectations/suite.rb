class Expectations::Suite
  
  include Mocha::Standalone
  
  def initialize
    @do_not_run = false
  end
  
  def xml(string)
    Expectations::XmlString.new(string)
  end
  
  def execute(out=STDOUT, suite_result = Expectations::SuiteResults.new(out))
    return suite_result if @do_not_run
    benchmark = Benchmark.measure do
      expectations_for(ENV["LINE"]).each { |expectation| suite_result << expectation.execute }
    end
    suite_result.print_results(benchmark)
    suite_result.write_junit_xml(ENV["JUnitXmlPath"]) unless ENV["JUnitXmlPath"].nil?
    suite_result
  end
  
  def expect(expected, &block)
    expectations << Expectations::Expectation.new(expected, *caller.first.split(/:/)[0..1], &block)
  end
  
  def do_not_run
    @do_not_run = true
  end
  
  def expectations_for(line)
    return expectations if line.nil?
    [expectations.inject { |result, expectation| expectation.line > line.to_i ? result : expectation }]
  end

  def expectations
    @expectations ||= []
  end
  
end