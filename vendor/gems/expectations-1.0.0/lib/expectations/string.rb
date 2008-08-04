class String
  def diff(other)
    (0..self.size).inject("") do |result, index|
      if self[index, 1] == other[index, 1]
        result += self[index, 1]
      else
        result += "[#{self[index, 1]}|#{other[index, 1]}], mismatch at index #{index}\n"
        result += "trailing expected: <#{self[index+1, self.size - index]}>\n"
        result += "trailing actual: <#{other[index+1, other.size - index]}>"
        return result
      end
      result
    end
  end
end