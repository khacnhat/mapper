require_relative 'test_base'

def find_dups(ls)
  counts = {}
  ls.each do |id|
    id4 = id[0..3]
    counts[id4] ||= 0
    counts[id4] += 1
  end
  keys = counts.select { |k,v| v > 1 }.keys
  keys == {} ? nil : keys[0]
end

# Used to find test data

class FindDupsTest < TestBase

  def self.hex_prefix
    '23E'
  end

  # - - - - - - - - - - - - - - - - -

  test '184',
  %w( find dups true ) do
    ls = %w(
      63616EDF	7A3171FB	9AA1DB94	B46AF873
      63619214  C6DBA25D	E374BF3A	FFEA3440
    )
    assert_equal '6361', find_dups(ls)
  end

  # - - - - - - - - - - - - - - - - -

  test '185',
  %w( find dups false ) do
    ls = %w(
      63616EDF	7A3171FB	9AA1DB94	B46AF873
      53619214  C6DBA25D	E374BF3A	FFEA3440
    )
    assert_nil find_dups(ls)
  end

end
