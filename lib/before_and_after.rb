module BeforeAndAfter
  LEFT_SIDE_LATER  = 1
  RIGHT_SIDE_LATER = -1
  
  def before?(input_time)
    (self <=> input_time) == RIGHT_SIDE_LATER
  end
  
  def after?(input_time)
    (self <=> input_time) == LEFT_SIDE_LATER
  end
end

Time.send :include , BeforeAndAfter
