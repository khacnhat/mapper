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

  # - - - - - - - - - - - - - - - - -

  test '813',
  %w( ported_id of unmatched partial_id is empty string ) do
    assert_equal '', ported_id('223344')
  end

  # - - - - - - - - - - - - - - - - -

  test '814',
  %w( ported_id of uniquely matched partial_id is the match, length==6 ) do
    assert_equal 'B975C1', ported_id('B975C1')
  end

  # - - - - - - - - - - - - - - - - -

  test '815',
  %w( ported_id of non-unique matched partial_id is empty string ) do
    assert_equal '', ported_id('33EBEA')
  end

  # - - - - - - - - - - - - - - - - -

  test '816',
  %w( ported_id of uniquely matched partial_id is the match, length==7 ) do
    assert_equal 'RpWCCP', ported_id('33EBEAC')
    assert_equal 'P5S6XX', ported_id('33EBEAE')
  end

end
