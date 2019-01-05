require_relative 'hex_mini_test'
require_relative '../src/mapper_service'

class TestBase < HexMiniTest

  def mapper
    MapperService.new
  end

  def unknown
    mapper.unknown
  end

  def ready?
    mapper.ready?
  end

  def sha
    mapper.sha
  end

  def mapped?(id6)
    mapper.mapped?(id6)
  end

  def mapped_id(partial_id)
    mapper.mapped_id(partial_id)
  end

end
