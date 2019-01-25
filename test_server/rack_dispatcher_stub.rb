
class RackDispatcherStub

  def ready?
    "hello from #{self.class.name}.ready?"
  end

  def sha
    "hello from #{self.class.name}.sha"
  end

  def mapped?(_id6)
    "hello from #{self.class.name}.mapped?"
  end

  def mapped_id(_partial_id)
    "hello from #{self.class.name}.mapped_id"
  end

end
