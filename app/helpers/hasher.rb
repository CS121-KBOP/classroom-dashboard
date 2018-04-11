module Hasher

	# In order to handle assignment and poll ids in the same system, we just shift poll ids up by half of our input space (MAX/2)
	# because of this, we have a slightly more convoluted pipline to unhash. The raw unhash function just gets the modified id
	# the unshashTagtoID function corrects poll ids (shifts them down as nessecary)
	# this wierd functionality is nessecary for the homepage controller



	MAX = 20**5-1; # the maximum number that can be hashed to
    CODESTRING = "dlgknmzxjbctfqsrwvhp"; # random ordering of the alphabet

	# a helper function that hashes an id number into an access tag
	# the poll variable is whether or not this is a poll, which if true, will offset the id hashed
    def hashIDtoTag(number, poll)
    	if poll
    		number = number + MAX/2
    	end
    	newnumber = (number / 4).to_i
    	if (number % 4 == 0)
    		newnumber = MAX/4 - newnumber
    	elsif (number % 4 == 1)
    		newnumber = 3*MAX/4 - newnumber
    	elsif (number % 4 == 2)
    		newnumber = MAX/2 -  newnumber
    	else
    		newnumber = MAX - newnumber
    	end
    	result = ""
    	puts newnumber
    	for i in 1..5
    		result += CODESTRING[newnumber % 20]
    		newnumber /= 20
    	end

  		return (result[2]+result[0]+result[4]+result[3]+result[1]).upcase
    end

    # a helper that gets a proper poll or assignment ID from an access tag
    def unhashTagtoID(tag)
    	id = unhashTag(tag)
    	if id >= MAX/2
    		id = id - MAX/2
    	end
    	return id
    end

    # a helper that returns true if a tag corresponds to a helper id
    def isPollTag(tag)
    	id = unhashTag(tag)
    	return (id >= MAX/2)
    end


    # a hidden helper function that unhashes an access tag raw, without poll/assignment distinction
    def unhashTag(hash)
    	hash = (hash[1]+hash[4]+hash[0]+hash[3]+hash[2]).downcase
    	newnumber = 0
    	for i in (4).downto(0)
    		newnumber *= 20
    		newnumber += CODESTRING.index(hash[i])
    	end
    	if (newnumber <= MAX/4)
    		newnumber = (MAX/4 - newnumber)*4
    	elsif (newnumber <= MAX/2)
    		newnumber = (MAX/2 - newnumber) * 4 + 2
    	elsif (newnumber <= 3 * MAX / 4)
    		newnumber = (3*MAX/4 - newnumber) * 4 + 1
    	else
    		newnumber = (MAX - newnumber) * 4 + 3
    	end

    	return newnumber;
    end
end