require_relative 'client_error'
require 'json'

# Checks for arguments syntactic correctness

class WellFormedArgs

  def initialize(s)
    @args = JSON.parse(s)
  rescue
    raise ClientError.new('json:malformed')
  end

end
