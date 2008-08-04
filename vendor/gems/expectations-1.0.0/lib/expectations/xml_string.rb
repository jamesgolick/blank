class Expectations::XmlString < String
  
  def expectations_equal_to(other)
    not Regexp.new(Regexp.escape(normalize(self))).match(normalize(other)).nil?
  end
  
  def inspect
    "[as xml] #{normalize(self)}"
  end
  
  protected
  
  def normalize(xml_string)
    xml_string.strip.gsub(/>\s*</, "><")
  end
  
end