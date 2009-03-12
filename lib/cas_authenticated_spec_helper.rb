module CASAuthenticatedSpecHelper
  def login_as_user
    @current_user = mock_model(User, :login => "jsmith")
    User.should_receive(:find_by_login).with(@current_user.login).
      any_number_of_times.and_return(@current_user)
    User.should_receive(:staff_or_admin?).any_number_of_times.and_return(false)
    User.should_receive(:admin?).any_number_of_times.and_return(false)
    request.session[:cas_user] = @current_user.login
    request.session[:user_id] = @current_user.id
  end

  def login_as_staff
    @current_user = mock_model(User, :login => "jsmith")
    User.should_receive(:find_by_login).with(@current_user.login).
      any_number_of_times.and_return(@current_user)
    @current_user.should_receive(:staff_or_admin?).any_number_of_times.and_return(true)
    @current_user.should_receive(:admin?).any_number_of_times.and_return(false)
    request.session[:cas_user] = @current_user.login
    request.session[:user_id] = @current_user.id
  end

  def login_as_staff
    @current_user = mock_model(User, :login => "jsmith")
    User.should_receive(:find_by_login).with(@current_user.login).
      any_number_of_times.and_return(@current_user)
    @current_user.should_receive(:staff_or_admin?).any_number_of_times.and_return(true)
    @current_user.should_receive(:admin?).any_number_of_times.and_return(true)
    request.session[:cas_user] = @current_user.login
    request.session[:user_id] = @current_user.id
  end
end
