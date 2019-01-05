
class Mapper

  def ready?
    true
  end

  # Used by saver service, exposed by dispatcher
  def mapped?(id6)
    dir_glob(id6).size > 0
  end

  # Used by web service, exposed by dispatcher
  def mapped_id(partial_id)
    globs = dir_glob(partial_id)
    if globs.size == 1
      IO.read(globs[0])
    else
      ''
    end
  end

  private

  def dir_glob(id)
    id2 = id[0..1]
    id4 = id[2..-1]
    path = "/porter/mapped-ids/#{id2}/#{id4}**"
    Dir.glob(path)
  end

end
