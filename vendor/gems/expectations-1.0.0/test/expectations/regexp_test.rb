require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect true do
    /foo/.expectations_equal_to "foo"
  end

  expect true do
    /foo/.expectations_equal_to /foo/
  end
end