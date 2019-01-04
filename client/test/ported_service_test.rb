require_relative '../src/service_error'
require_relative 'test_base'

class PortedServiceTest < TestBase

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
    assert_equal 'PortedService', json['class']
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
  # ported?(id6)
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '211',
  %w( ported?(id6) false ) do
    refute ported?('112233')
    refute ported?('332211')
  end

  test '212',
  %w( ported?(id6) true ) do
    assert ported?('33EBEA')
    assert ported?('B975C1')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ported_id(partial_id)
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '37B',
  %w( ported_id of unmatched partial_id is empty string ) do
    assert_equal '', ported_id('223344')
  end

  test '37C',
  %w( ported_id of uniquely matched partial_id is the match, length==6 ) do
    assert_equal 'B975C1', ported_id('B975C1')
  end

  test '37D',
  %w( ported_id of non-unique matched partial_id is empty string ) do
    assert_equal '', ported_id('33EBEA')
  end

  test '37E',
  %w( ported_id of uniquely matched partial_id is the match, length==7 ) do
    assert_equal 'RpWCCP', ported_id('33EBEAC')
    assert_equal 'P5S6XX', ported_id('33EBEAE')
  end

end
