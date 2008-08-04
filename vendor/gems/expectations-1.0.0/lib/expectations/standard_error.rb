class Expectations::StandardError
  def self.print(string)
    print_suggestion
    STDERR.print string
  end
  
  def self.print_suggestion
    return if @suggestion_printed
    @suggestion_printed = true
    STDERR.print "Expectations allows you to to create multiple mock expectations, but suggests that you write another test instead.\n"
  end
end