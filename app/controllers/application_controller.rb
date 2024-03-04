class ApplicationController < ActionController::Base
  def current_user
    User.new(id: 0, name: 'Alice')
  end
  helper_method :current_user
end
