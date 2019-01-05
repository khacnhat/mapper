require_relative 'hex_mini_test'
require_relative '../src/externals'

class TestBase < HexMiniTest

  def ready?
    mapper.ready?
  end

  def sha
    env.sha
  end

  def mapped?(id6)
    mapper.mapped?(id6)
  end

  def mapped_id(partial_id)
    mapper.mapped_id(partial_id)
  end

  # - - - - - - - - - - - - - -

  def mapper
    externals.mapper
  end

  def env
    externals.env
  end

  def externals
    @externals ||= Externals.new
  end

end
