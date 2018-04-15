class HomepageController < ApplicationController
	include Hasher

    def index
    end

    def access_submission_page
    	is_poll = isPollTag(params[:access_tag])

    	if is_poll
    		redirect_to controller: "polls", action: "student_show" and return
    	else
    		redirect_to controller: "submissions", action: "new" and return
        end
        return
    end
end
