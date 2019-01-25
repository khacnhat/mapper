require_relative '../src/service_error'
require_relative 'test_base'

class MapperServiceTest < TestBase

  def self.hex_prefix
    'D06'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # unknown
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '188',
  %w( unknown ) do
    error = assert_raises(ServiceError) { unknown }
    json = JSON.parse!(error.message)
    assert_equal 'MapperService', json['class']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ready?
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '189',
  %w( ready? ) do
    assert ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # sha
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '190',
  %w( sha ) do
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # mapped?(id6)
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '211',
  %w( mapped?(id6) false ) do
    refute mapped?('112233')
    refute mapped?('332211')
  end

  test '212',
  %w( mapped?(id6) true ) do
    assert mapped?('33EBEA')
    assert mapped?('B975C1')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # mapped_id(partial_id)
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '37B',
  %w( mapped_id of unmatched partial_id is unchanged partial_id ) do
    assert_equal '223344', mapped_id('223344')
  end

  test '37C',
  %w( mapped_id of uniquely matched partial_id is the match, length==6 ) do
    assert_equal 'B975C1', mapped_id('B975C1')
  end

  test '37D',
  %w( mapped_id of non-unique matched partial_id is unchanged partial_id ) do
    assert_equal '33EBEA', mapped_id('33EBEA')
  end

  test '37E',
  %w( mapped_id of uniquely matched partial_id is the match, length==7 ) do
    assert_equal 'RpWCCP', mapped_id('33EBEAC')
    assert_equal 'P5S6XX', mapped_id('33EBEAE')
  end

end
