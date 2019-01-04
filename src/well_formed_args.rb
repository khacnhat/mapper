require_relative 'client_error'
require 'json'

# Checks for arguments syntactic correctness

class WellFormedArgs

  def initialize(s)
    @args = JSON.parse(s)
  rescue
    raise ClientError.new('json:malformed')
  end

  # - - - - - - - - - - - - - - -

  def id6
    @arg_name = __method__.to_s
    unless Base58.string?(arg)
      malformed('!Base58')
    end
    unless arg.size == 6
      malformed("size==#{arg.size} !6")
    end
    arg
  end

  # - - - - - - - - - - - - - - -

  def partial_id
    @arg_name = __method__.to_s
    unless Base58.string?(arg)
      malformed('!Base58')
    end
    unless (6..10).include?(arg.size)
      malformed("size==#{arg.size} !(6..10)")
    end
    arg
  end

  private

  attr_reader :args,
              :arg_name

  def arg
    args[arg_name]
  end

  # - - - - - - - - - - - - - - - -

  def malformed(msg)
    raise ClientError.new("#{arg_name}:malformed:#{msg}:")
  end

end
