require_relative 'hex_mini_test'
require_relative '../src/externals'

class TestBase < HexMiniTest

  def externals
    @externals ||= Externals.new
  end

  def ported?(id6)
    ported.ported?(id6)
  end

  def ported_id(partial_id)
    ported.ported_id(partial_id)
  end

  # - - - - - - - - - - - - - -

  def ported
    externals.ported
  end

  def env
    externals.env
  end

end
