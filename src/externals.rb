require_relative 'external_env'
require_relative 'ported'

class Externals

  def env
    @env ||= ExternalEnv.new
  end

  def ported
    @ported ||= Ported.new
  end

end
