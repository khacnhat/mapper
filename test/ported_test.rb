require_relative 'test_base'

class PortedTest < TestBase

  def self.hex_prefix
    'D71'
  end

  # - - - - - - - - - - - - - - - - -

  test '9D1',
  %w( ported?(id6) is false if id6 is not a mapped-id ) do
    refute ported?('112233')
    refute ported?('332211')
  end

  # - - - - - - - - - - - - - - - - -

  test '9D2',
  %w( ported?(id6) is true if id6 is mapped-id ) do
    assert ported?('33EBEA')
    assert ported?('B975C1')
  end

end
