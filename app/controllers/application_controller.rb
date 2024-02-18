class ApplicationController < ActionController::Base
  def current_user
    User.new(id: 1, name: 'Alice')
  end
  helper_method :current_user
end
