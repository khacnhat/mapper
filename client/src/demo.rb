require_relative 'ported_service'

class Demo

  def call(_env)
    inner_call
  rescue => error
    [ 200, { 'Content-Type' => 'text/html' }, [ error.message ] ]
  end

  def inner_call
    @html = ''
    ready?
    sha
    ported?
    ported_id
    [ 200, { 'Content-Type' => 'text/html' }, [ @html ] ]
  end

  private

  def ready?
    result,duration = timed { ported.ready? }
    @html += pre('ready?', duration, 'moccasin', result)
  end

  def sha
    result,duration = timed { ported.sha }
    @html += pre('sha', duration, 'moccasin', result)
  end

  def ported?
    result,duration = timed { ported.ported?('33EBEA') }
    @html += pre("ported?('33EBEA')", duration, 'moccasin', result)
  end

  def ported_id
    result,duration = timed { ported.ported_id('33EBEAC') }
    @html += pre("ported_id('33EBEAC')", duration, 'moccasin', result)
  end

  def ported
    PortedService.new
  end

  def timed
    started = Time.now
    result = yield
    finished = Time.now
    duration = '%.3f' % (finished - started)
    [result,duration]
  end

  def pre(name, duration, colour = 'white', result = nil)
    border = 'border: 1px solid black;'
    padding = 'padding: 5px;'
    margin = 'margin-left: 30px; margin-right: 30px;'
    background = "background: #{colour};"
    whitespace = "white-space: pre-wrap;"
    html = "<pre>(#{duration}s) /#{name}</pre>"
    unless result.nil?
      html += "<pre style='#{whitespace}#{margin}#{border}#{padding}#{background}'>" +
              "#{JSON.pretty_unparse(result)}" +
              '</pre>'
    end
    html
  end

end
