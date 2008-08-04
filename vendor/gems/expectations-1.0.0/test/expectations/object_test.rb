require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect true do
    object = Object.new
    object.expectations_equal_to object
  end

  expect false do
    Object.new.expectations_equal_to Object.new
  end
end