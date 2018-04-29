class HasherTest < ActionView::TestCase
  include Hasher
  test "assignment hashes should be unique" do
    max_value = (20**5)/2 - 1 # 5 letters, 20 options, 0 indexed, split across assignments and polls
    # collect all hashes
  	hashes = Array.new
  	for i in 0..max_value
      hashes.push(hashIDtoTag(i, false)) # not a poll
	  end
	  num_hashes = hashes.uniq().length
	  assert_equal(max_value+1, num_hashes, "Number of unique hashes not equal to number of inputs, hashes are not unique")
  end

  test "poll hashes should be unique" do
    max_value = (20**5)/2 - 1 # 5 letters, 20 options, 0 indexed, split across assignments and polls
    # collect all hashes
    hashes = Array.new
    for i in 0..max_value
      hashes.push(hashIDtoTag(i, true)) # a poll
    end
    num_hashes = hashes.uniq().length
    assert_equal(max_value+1, num_hashes, "Number of unique hashes not equal to number of inputs, hashes are not unique")
  end

  test "should hash and unhash assignments properly" do
  	max_value = (20**5)/2 - 1 # 5 letters, 20 options, 0 indexed, split across assignments and polls
  	# make sure every number hashes to itself
  	for i in 0..max_value
	    hashed = hashIDtoTag(i, false) # not a poll
	    unhashed = unhashTagtoID(hashed)
	    assert_equal( unhashed, i, "values "+i.to_s+" was hashed to "+hashed.to_s+" then back to "+unhashed.to_s )
	  end
  end

  test "should hash and unhash polls properly" do
    max_value = (20**5)/2 - 1 # 5 letters, 20 options, 0 indexed, split across assignments and polls
    # make sure every number hashes to itself
    for i in 0..max_value
      hashed = hashIDtoTag(i, true) # a poll
      unhashed = unhashTagtoID(hashed)
      assert_equal( unhashed, i, "values "+i.to_s+" was hashed to "+hashed.to_s+" then back to "+unhashed.to_s )
    end
  end
end
