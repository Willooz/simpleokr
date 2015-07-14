class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def meta_events_tracker
    @meta_events_tracker ||= MetaEvents::Tracker.new(nil, request.remote_ip)
  end

end
