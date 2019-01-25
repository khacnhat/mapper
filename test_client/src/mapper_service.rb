require_relative 'http'

class MapperService

  def initialize
    @http = Http.new(self, 'mapper', 4547)
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

  def mapped?(id6)
    http.get(id6)
  end

  def mapped_id(partial_id)
    http.get(partial_id)
  end

  private

  attr_reader :http

end
