require_relative 'hex_mini_test'
require_relative '../src/ported_service'

class TestBase < HexMiniTest

  def ported
    PortedService.new
  end

  def ready?
    ported.ready?
  end

  def sha
    ported.sha
  end

  def ported?(id6)
    ported.ported?(id6)
  end

  def ported_id(partial_id)
    ported.ported_id(partial_id)
  end

end
