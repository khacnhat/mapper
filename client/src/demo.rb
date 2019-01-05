require_relative 'mapper_service'

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
    mapped?
    mapped_id
    [ 200, { 'Content-Type' => 'text/html' }, [ @html ] ]
  end

  private

  def ready?
    result,duration = timed { mapper.ready? }
    @html += pre('ready?', duration, 'moccasin', result)
  end

  def sha
    result,duration = timed { mapper.sha }
    @html += pre('sha', duration, 'moccasin', result)
  end

  def mapped?
    result,duration = timed { mapper.mapped?('33EBEA') }
    @html += pre("mapped?('33EBEA')", duration, 'moccasin', result)
  end

  def mapped_id
    result,duration = timed { mapper.mapped_id('33EBEAC') }
    @html += pre("mapped_id('33EBEAC')", duration, 'moccasin', result)
  end

  def mapper
    MapperService.new
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
