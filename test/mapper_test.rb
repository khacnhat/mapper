require_relative 'test_base'

class MapperTest < TestBase

  def self.hex_prefix
    'D71'
  end

  # - - - - - - - - - - - - - - - - -

  test '9D1',
  %w( mapped?(id6) is false if id6 is not a mapped-id ) do
    refute mapped?('112233')
    refute mapped?('332211')
  end

  # - - - - - - - - - - - - - - - - -

  test '9D2',
  %w( mapped?(id6) is true if id6 is mapped-id ) do
    assert mapped?('33EBEA')
    assert mapped?('B975C1')
  end

  # - - - - - - - - - - - - - - - - -

  test '813',
  %w( mapped_id of unmatched partial_id is empty string ) do
    assert_equal '', mapped_id('223344')
  end

  # - - - - - - - - - - - - - - - - -

  test '814',
  %w( mapped_id of uniquely matched partial_id is the match, length==6 ) do
    assert_equal 'B975C1', mapped_id('B975C1')
  end

  # - - - - - - - - - - - - - - - - -

  test '815',
  %w( mapped_id of non-unique matched partial_id is empty string ) do
    assert_equal '', mapped_id('33EBEA')
  end

  # - - - - - - - - - - - - - - - - -

  test '816',
  %w( mapped_id of uniquely matched partial_id is the match, length==7 ) do
    assert_equal 'RpWCCP', mapped_id('33EBEAC')
    assert_equal 'P5S6XX', mapped_id('33EBEAE')
  end

end
