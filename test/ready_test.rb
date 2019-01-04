require_relative 'test_base'

class ReadyTest < TestBase

  def self.hex_prefix
    '0B2'
  end

  def ready
    ported.ready
  end

  # - - - - - - - - - - - - - - - - -

  test '602',
  %w( ready ) do
    assert ready
  end

end
