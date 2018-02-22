module SessionsHelper
  def not_found
    render 'sessions/unauthorized'
  end

  def proper_user(user)
    if session[:user] != current_user
      not_found
    end
  end
end
