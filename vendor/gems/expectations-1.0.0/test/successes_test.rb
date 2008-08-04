require File.dirname(__FILE__) + "/test_helper"

Expectations do

  # State based expectation where a value equals another value
  expect 2 do
    1 + 1
  end

  # State based expectation where an exception is expected. Simply expect the Class of the intended exception
  expect NoMethodError do
    Object.no_method
  end

  # Behavior based test using a traditional mock
  expect mock.to.receive(:dial).with("2125551212").times(2) do |phone|
    phone.dial("2125551212")
    phone.dial("2125551212")
  end

  # Behavior based test using a stub
  expect stub.to.receive(:dial).with("2125551212").times(2) do |phone|
    phone.dial("2125551212")
    phone.dial("2125551212")
  end

  # Behavior based test using a stub_everything
  expect stub_everything.to.receive(:dial).with("2125551212").times(2) do |phone|
    phone.dial("2125551212")
    phone.dial("2125551212")
  end

  # Behavior based test on a concrete mock
  expect Object.to.receive(:deal) do
    Object.deal
  end

  # State based test utilizing a stub
  expect 2 do
    stub(:two => 2).two
  end

  # State based test matching a Regexp
  expect /a string/ do
    "a string"
  end

  # State based test checking if actual is in the expected Range
  expect 1..5 do
    3
  end

  # State based test to determine if the object is an instance of the module
  expect Enumerable do
    []
  end

  # State based test to determine if the object is an instance of the class
  expect String do
    "a string"
  end

  # State based test to determine if the modules are the same
  expect Enumerable do
    Enumerable
  end

  # State based test to determine if the classes are the same
  expect String do
    String
  end

  # State based test with XML strings, whitespace between tags is ignored
  expect xml("<a><foo>bar</foo></a>") do
    "<a>\n\t<foo>bar</foo>  \n</a>"
  end

  # State based test with XML strings, whitespace between tags is ignored
  expect xml(<<-eos) do
    <one>
    <two>
    <three>4</three>
    <five> 6 </five>
    </two>
    </one>
    eos
    "<one><two><three>4</three>
    <five> 6 </five>
    </two></one>"
  end

  # this is normally defined in the file specific to the class
  klass = Class.new do
    def save(arg)
      record.save(arg)
    end
  end
  # State based delegation test
  expect klass.new.to.delegate(:save).to(:record) do |instance|
    instance.save(1)
  end

  # this is normally defined in the file specific to the class
  klass = Class.new do
    attr_accessor :started
  end
  # State based fluent interface boolean test using to be
  expect klass.new.to.be.started do |process|
    process.started = true
  end

  # this is normally defined in the file specific to the class
  klass = Class.new do
    attr_accessor :finished
  end
  # State based fluent interface boolean test using to have
  expect klass.new.to.have.finished do |process|
    process.finished = true
  end

  expect nil.to.be.nil?
  expect Object.not.to.be.nil?

end