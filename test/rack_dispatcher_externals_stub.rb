
class RackDispatcherExternalsStub

  def initialize(stub)
    @stub = stub
  end

  attr_reader :stub

  def env
    stub
  end

  def mapper
    stub
  end

end
