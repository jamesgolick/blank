require File.dirname(__FILE__) + "/../test_helper"

Expectations do
  expect true do
    Expectations::XmlString.new("<foo>bar</foo>").expectations_equal_to "<foo>bar</foo>"
  end

  expect false do
    Expectations::XmlString.new("<foo>not bar</foo>").expectations_equal_to "<foo>bar</foo>"
  end

  expect false do
    Expectations::XmlString.new("<not-foo>bar</not-foo>").expectations_equal_to "<foo>bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("<foo>bar</foo>").expectations_equal_to "  <foo>bar</foo>  "
  end

  expect true do
    Expectations::XmlString.new("  <foo>bar</foo>  ").expectations_equal_to "<foo>bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("<foo>bar</foo>").expectations_equal_to "<foo>bar</foo>\n"
  end

  expect true do
    Expectations::XmlString.new("\n<foo>bar</foo>").expectations_equal_to "<foo>bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("\t<foo>bar</foo>").expectations_equal_to "<foo>bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("<foo>bar</foo>").expectations_equal_to "<foo>bar</foo>\t"
  end

  expect true do
    Expectations::XmlString.new("<a>\n<foo>bar</foo>").expectations_equal_to "<a><foo>bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("<a>\n<foo>\t \n bar</foo>").expectations_equal_to "<a><foo>\t \n bar</foo>"
  end

  expect true do
    Expectations::XmlString.new("<a>\n<foo>\t \n bar</foo>\n \t </a>").expectations_equal_to "<a><foo>\t \n bar</foo></a>"
  end

  expect true do
    Expectations::XmlString.new("<fragment>content</fragment>").expectations_equal_to "<container><fragment>content</fragment></container>"
  end

  expect true do
    Expectations::XmlString.new('<?xml version="1.0"?>').expectations_equal_to '<?xml version="1.0"?>'
  end

  expect "[as xml] <fragment>content</fragment>" do
    Expectations::XmlString.new("  \t<fragment>content</fragment>\n  ").inspect
  end

end