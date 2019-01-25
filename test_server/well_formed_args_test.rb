require_relative 'test_base'
require_relative '../src/well_formed_args'

class WellFormedArgsTest < TestBase

  def self.hex_prefix
    '0A1'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # c'tor
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A04',
  'ctor raises when its string arg is not valid json' do
    expected = 'json:malformed'
    # abc is not a valid top-level json element
    error = assert_raises { WellFormedArgs.new('abc') }
    assert_equal expected, error.message
    # nil is null in json
    error = assert_raises { WellFormedArgs.new('{"x":nil}') }
    assert_equal expected, error.message
    # keys have to be strings in json
    error = assert_raises { WellFormedArgs.new('{42:"answer"}') }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # id6
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '61A',
  'id6 does not raise when well-formed' do
    id6 = 'A1B2kn'
    json = { id6:id6 }.to_json
    assert_equal id6, WellFormedArgs.new(json).id6
  end

  test '61B',
  'id6 raises when malformed' do
    malformed_id6s.each do |malformed,message|
      json = { id6:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.id6 }
      expected = "id6:malformed:#{message}:"
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_id6s
    {
      nil      => '!Base58',
      []       => '!Base58',
      '12345/' => '!Base58',
      ''        => 'size==0 !6',
      '12'      => 'size==2 !6',
      '12345'   => 'size==5 !6',
      '1234567' => 'size==7 !6',
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # partial_id
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '62A',
  'partial_id does not raise when well-formed' do
    well_formed_partial_ids.each do |partial_id|
      json = { partial_id:partial_id }.to_json
      assert_equal partial_id, WellFormedArgs.new(json).partial_id
    end
  end

  test '62B',
  'partial_id raises when malformed' do
    malformed_partial_ids.each do |malformed,message|
      json = { partial_id:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.partial_id }
      expected = "partial_id:malformed:#{message}:"
      assert_equal expected, error.message, malformed
    end
  end

  def well_formed_partial_ids
    %w( A1B2kn
        A1B2knA
        A1B2knA8
        A1B2knA8w
        A1B2knA8wS
    )
  end

  def malformed_partial_ids
    {
      nil      => '!Base58',
      []       => '!Base58',
      '12^345' => '!Base58',
      ''        => 'size==0 !(6..10)',
      '12'      => 'size==2 !(6..10)',
      '12345'   => 'size==5 !(6..10)',
      '123456789A1' => 'size==11 !(6..10)',
    }
  end

end
