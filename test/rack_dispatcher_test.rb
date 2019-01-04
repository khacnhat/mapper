require_relative 'rack_dispatcher_externals_stub'
require_relative 'rack_dispatcher_stub'
require_relative 'rack_request_stub'
require_relative 'test_base'
require_relative '../src/rack_dispatcher'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'FF0'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  class ThrowingRackDispatcherStub
    def ported?(_id6)
      fail ArgumentError, 'wibble'
    end
  end

  test 'F1A',
  'dispatch returns 500 status when implementation raises' do
    @stub = ThrowingRackDispatcherStub.new
    assert_dispatch_raises('ported?',
      { id6:'123456' }.to_json,
      500,
      'wibble')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F1B',
  'dispatch raises when method name is unknown' do
    assert_dispatch_raises('xyz',
      {}.to_json,
      400,
      'xyz:unknown:')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F1C',
  'dispatch raises when json is malformed' do
    assert_dispatch_raises('ported?',
      'xxx',
      400,
      'json:malformed')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ready?
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E42',
  'dispatch to ready' do
    assert_dispatch('ready?', {}.to_json,
      "hello from #{stub_name}.ready?"
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # sha
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E41',
  'dispatch to sha' do
    assert_dispatch('sha', {}.to_json,
      "hello from #{stub_name}.sha"
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ported?
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5B',
  'dispatch to ported? raises when id6 is not Base58 string' do
    bad_char = '&'
    id6 = "abc#{bad_char}def"
    assert_dispatch_raises('ported?',
      { id6:id6 }.to_json,
      400,
      'id6:malformed:!Base58:'
    )
  end

  test 'E5C',
  'dispatch to ported? raises when id6 is less than 6 chars long' do
    id6 = '12345'
    assert_equal 5, id6.size
    assert_dispatch_raises('ported?',
      { id6:id6 }.to_json,
      400,
      'id6:malformed:size==5 !6:'
    )
  end

  test 'E5D',
  'dispatch to ported? raises when id is more than 6 chars long' do
    id6 = '1234567'
    assert_equal 7, id6.size
    assert_dispatch_raises('ported?',
      { id6:id6 }.to_json,
      400,
      'id6:malformed:size==7 !6:'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E61',
  'dispatch to ported? with id of 6 chars does not raise' do
    id6 = '123456'
    assert_equal 6, id6.size
    assert_dispatch('ported?',
      { id6:id6 }.to_json,
      "hello from #{stub_name}.ported?"
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ported_id
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C22',
  'dispatch to ported_id raises when partial_id is not Base58 string' do
    bad_char = '&'
    partial_id = "abc#{bad_char}def"
    assert_dispatch_raises('ported_id',
      { partial_id:partial_id }.to_json,
      400,
      'partial_id:malformed:!Base58:'
    )
  end

  test 'C23',
  'dispatch to ported_id raises when partial_id is less than 6 chars long' do
    partial_id = "abcde"
    assert_equal 5, partial_id.size
    assert_dispatch_raises('ported_id',
      { partial_id:partial_id }.to_json,
      400,
      'partial_id:malformed:size==5 !(6..10):'
    )
  end

  test 'C24',
  'dispatch to ported_id raises when partial_id is more than 10 chars long' do
    partial_id = "abcde12345X"
    assert_equal 11, partial_id.size
    assert_dispatch_raises('ported_id',
      { partial_id:partial_id }.to_json,
      400,
      'partial_id:malformed:size==11 !(6..10):'
    )
  end

  test 'C25',
  'dispatch to ported_id with partial_id of 10 chars does not raise' do
    partial_id = "abcde12345"
    assert_equal 10, partial_id.size
    assert_dispatch('ported_id',
      { partial_id:partial_id }.to_json,
      "hello from #{stub_name}.ported_id"
    )
  end

  private

  def stub_name
    stub.class.name
  end

  def unquery(name)
    if name.end_with?('?')
      name = name[0..-2]
    end
    name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch(name, args, stubbed)
    uname = unquery(name)
    assert_rack_call(uname, args, { name => stubbed })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch_raises(name, args, status, message)
    uname = unquery(name)
    response,stderr = with_captured_stderr { rack_call(uname, args) }
    body = args
    assert_equal status, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    assert_exception(response[2][0], uname, body, message)
    assert_exception(stderr,         uname, body, message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_exception(s, name, body, message)
    json = JSON.parse(s)
    exception = json['exception']
    refute_nil exception
    assert_equal name, exception['path']
    assert_equal body, exception['body']
    assert_equal 'PortedService', exception['class']
    assert_equal message, exception['message']
    assert_equal 'Array', exception['backtrace'].class.name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call(name, args, expected)
    response = rack_call(name, args)
    assert_equal 200, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    assert_equal [to_json(expected)], response[2], args
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub
    @stub ||= RackDispatcherStub.new
  end

  def rack_call(name, args)
    externals_stub = RackDispatcherExternalsStub.new(stub)
    rack = RackDispatcher.new(externals_stub, RackRequestStub)
    env = { path_info:name, body:args }
    rack.call(env)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def to_json(body)
    JSON.generate(body)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def with_captured_stderr
    begin
      old_stderr = $stderr
      $stderr = StringIO.new('', 'w')
      response = yield
      return [ response, $stderr.string ]
    ensure
      $stderr = old_stderr
    end
  end

end
