# This controller handles the logout function of the site.  
class SessionsController < ApplicationController
  def destroy
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
