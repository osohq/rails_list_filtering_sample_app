class ApplicationController < ActionController::Base
  # Authentication not yet implemented
  def current_user
    User.new(id: 0, name: 'Alice')
  end
  helper_method :current_user
end
