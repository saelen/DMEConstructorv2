class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper
  include SessionsHelper

  before_filter :signed_in_user
end
