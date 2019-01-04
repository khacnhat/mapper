
class RackDispatcherStub

  def ready?
    "hello from #{self.class.name}.ready?"
  end

  def sha
    "hello from #{self.class.name}.sha"
  end

  def ported?(_id6)
    "hello from #{self.class.name}.ported?"
  end

  def ported_id(_partial_id)
    "hello from #{self.class.name}.ported_id"
  end

end
