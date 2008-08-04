require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect "fo[o|a], mismatch at index 2\ntrailing expected: < bar baz>\ntrailing actual: < bar bat>" do
    "foo bar baz".diff("foa bar bat")
  end
end