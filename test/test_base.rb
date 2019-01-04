require_relative 'hex_mini_test'
require_relative '../src/externals'

class TestBase < HexMiniTest

  def externals
    @externals ||= Externals.new
  end

  def ported
    externals.ported
  end

  def env
    externals.env
  end

end
