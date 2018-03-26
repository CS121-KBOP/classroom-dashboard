class AssignmentsHelperTest < ActionView::TestCase
  test "hashes should be unique" do
  	max_value = 26**4-1 # 4 letters, 26 options, 0 indexed
  	# collect all hashes
  	hashes = Array.new
  	for i in 0..max_value
	   hashes.push(hashID(i))
	end
	num_hashes = hashes.uniq().length
	assert_equal(max_value+1, num_hashes, "Number of unique hashes not equal to number of inputs, hashes are not unique")
  end

  test "should hash and unhash properly" do
  	max_value = 26**4-1 # 4 letters, 26 options, 0 indexed
  	# make sure every number hashes to itself
  	for i in 0..max_value
	   hashed = hashID(i)
	   unhashed = unhashTag(hashed)
	   assert_equal( unhashed, i, "values "+i.to_s+" was hashed to "+hashed.to_s+" then back to "+unhashed.to_s )
	end
  end
end