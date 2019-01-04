require_relative 'http_helper'

class PortedService

  def initialize
    @http = HttpHelper.new(self, 'ported', 4547)
  end

  def unknown
    http.get
  end

  def ready?
    http.get
  end

  def sha
    http.get
  end

  def ported?(id6)
    http.get(id6)
  end

  def ported_id(partial_id)
    http.get(partial_id)
  end

  private

  attr_reader :http

end
