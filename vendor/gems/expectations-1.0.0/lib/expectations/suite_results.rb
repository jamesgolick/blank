class Expectations::SuiteResults
  attr_accessor :out, :expectations

  def initialize(out)
    self.out, self.expectations = out, []
    out.print "Expectations "
  end

  def <<(expectation_result)
    out.print expectation_result.char
    self.expectations << expectation_result
    self
  end

  def succeeded?
    expectations.all? { |expectation| expectation.fulfilled? }
  end

  def fulfilled
    expectations.select { |expectation| expectation.fulfilled? }
  end

  def errors
    expectations.select { |expectation| expectation.error? }
  end

  def failures
    expectations.select { |expectation| expectation.failure? }
  end
  
  def print_results(benchmark)
    run_time = benchmark.real
    run_time = 0.001 if run_time < 0.001
    out.puts "\nFinished in #{run_time.to_s.gsub(/(\d*)\.(\d{0,5}).*/,'\1.\2')} seconds"
    if succeeded?
      print_success 
    else
      print_fail
    end
  end
  
  def print_success
    out.puts "\nSuccess: #{fulfilled.size} fulfilled"
  end

  def print_fail
    out.puts "\nFailure: #{failures.size} failed, #{errors.size} errors, #{fulfilled.size} fulfilled"
    out.puts "\n--Errors--" if errors.any?
    errors.each do |error|
      out.puts " #{error.file}:#{error.line}:in `expect'" if ENV["TM_MODE"]
      out.puts "file <#{error.file}>"
      out.puts "line <#{error.line}>"
      out.puts "error <#{error.exception.message}>"
      out.puts "trace #{filter_backtrace(error.exception.backtrace)}"
      out.puts "#{error.message}" if error.message && error.message.any?
      out.puts "\n"
    end
    out.puts "\n--Failures--" if failures.any?
    failures.each do |failure|
      out.puts " #{failure.file}:#{failure.line}:in `expect'" if ENV["TM_MODE"]
      out.puts "file <#{failure.file}>"
      out.puts "line <#{failure.line}>"
      out.puts "#{failure.message}\n\n"
    end
  end

  def write_junit_xml(path)
    FileUtils.rm_rf path if File.exist?(path)
    FileUtils.mkdir_p path
    grouped_expectations = expectations.inject({}) do |result, expectation| 
      result[expectation.file] = [] if result[expectation.file].nil?
      result[expectation.file] << expectation
      result
    end
    grouped_expectations.keys.each do |file_name|
      class_name = "#{File.basename(file_name, ".rb")}.xml"
      File.open("#{path}/TEST-#{class_name}", "w") do |file|
        file << '<?xml version="1.0" encoding="UTF-8" ?>'
        grouped_fulfilled = grouped_expectations[file_name].select { |expectation| expectation.fulfilled? }
        grouped_errors = grouped_expectations[file_name].select { |expectation| expectation.error? }
        grouped_failures = grouped_expectations[file_name].select { |expectation| expectation.failure? }
        file << %[<testsuite errors="#{grouped_errors.size}" skipped="0" tests="#{grouped_expectations[file_name].size}" time="0.00" failures="#{grouped_failures.size}" name="#{class_name}">]
        grouped_expectations[file_name].each do |expectation|
          file << %[<testcase time="0.0" name="line:#{expectation.line}">]
          file << %[<failure type="java.lang.AssertionError" message="#{ERB::Util.h(expectation.message)}"/>] if expectation.failure?
          file << %[</testcase>]
        end
        file << %[</testsuite>]
      end
    end
  end

  def filter_backtrace(trace)
    patterns_to_strip = [/\/expectations\/lib\/expectations\//, /\/lib\/ruby\/1\.8\//]
    result = patterns_to_strip.inject(trace) do |result, element|
      result = result.select { |line| line !~ element}
    end
    result.collect do |line|
      "\n  #{line}"
    end
  end
end