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
    @html += pre('ready?') { mapper.ready? }
  end

  def sha
    @html += pre('sha') { mapper.sha }
  end

  def mapped?
    @html += pre("mapped?('33EBEA')") { mapper.mapped?('33EBEA') }
  end

  def mapped_id
    @html += pre("mapped_id('33EBEAC')") { mapper.mapped_id('33EBEAC') }
  end

  def mapper
    MapperService.new
  end

  def pre(name, &block)
    result,duration = timed { block.call }
    colour = 'moccasin'
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

  def timed
    started = Time.now
    result = yield
    finished = Time.now
    duration = '%.3f' % (finished - started)
    [result,duration]
  end

end
