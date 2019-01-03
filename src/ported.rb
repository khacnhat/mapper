
class Ported

  def ready
  end

  # Used by saver service, exposed by dispatcher
  def ported?(id6)
    id2 = id6[0..1]
    id4 = id6[2..-1]
    path = "/porter/mapped-ids/#{id2}/#{id4}**"
    Dir.glob(path).size > 0
  end

  # Used by web service, exposed by dispatcher
  def ported_id(partial_id)
  end

end
