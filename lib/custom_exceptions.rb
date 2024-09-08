class InputError < StandardError
  def initialize(msg)
    @msg = msg
    super(msg)
  end
end

class InvalidPosition < StandardError
  def initialize(msg)
    @msg = msg
    super(msg)
  end
end
