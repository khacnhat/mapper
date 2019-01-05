require_relative 'external_env'
require_relative 'mapper'

class Externals

  def env
    @env ||= ExternalEnv.new
  end

  def mapper
    @ported ||= Mapper.new
  end

end
