module AssignmentsHelper
	MAX = 26**4-1; # the maximum number that can be hashed to
    CODESTRING = "ydlgknmzxjbctfiaqsrwoevuhp"; # random ordering of the alphabet

	# a helper function that hashes an assignment number into a tag
    def hashID(number)
    	newnumber = (number / 4).to_i;
    	if (number % 4 == 0)
    		newnumber = MAX/4 - newnumber;
    	elsif (number % 4 == 1)
    		newnumber = 3*MAX/4 - newnumber;
    	elsif (number % 4 == 2)
    		newnumber = MAX/2 -  newnumber;
    	else
    		newnumber = MAX - newnumber;
    	end
    	result = "";
    	puts newnumber;
    	for i in 1..4
    		result += CODESTRING[newnumber % 26];
    		newnumber /= 26;
    	end
  		
  		return (result[2]+result[0]+result[3]+result[1]).upcase
    end

      # a helper function that unhashes an assignment tag
    def unhashTag(hash)
    	hash = (hash[1]+hash[3]+hash[0]+hash[2]).downcase;
    	newnumber = 0;
    	for i in (3).downto(0)
    		newnumber *= 26;
    		newnumber += CODESTRING.index(hash[i]);
    	end
    	if (newnumber <= MAX/4)
    		newnumber = (MAX/4 - newnumber)*4;
    	elsif (newnumber <= MAX/2)
    		newnumber = (MAX/2 - newnumber) * 4 + 2;
    	elsif (newnumber <= 3 * MAX / 4)
    		newnumber = (3*MAX/4 - newnumber) * 4 + 1;
    	else
    		newnumber = (MAX - newnumber) * 4 + 3;
    	end

    	return newnumber;
    end
end
