require_relative 'http_json_service'

class PortedService

  def ready?
    get(__method__)
  end

  def sha
    get(__method__)
  end

  def ported?(id6)
    get(__method__, id6)
  end

  def ported_id(partial_id)
    get(__method__, partial_id)
  end

  private

  include HttpJsonService

end
