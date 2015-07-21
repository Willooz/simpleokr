class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    session[:user_id] ||= SecureRandom.hex(6)
  end

  def mixpanel_tracker
    @mixpanel_tracker ||= Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])
  end

  def track_event(user, event)
    # Track an event on behalf of user "User1"
    # mixpanel_tracker.track('User1', 'A Mixpanel Event')
    mixpanel_tracker.track(user, event)
  end

  def record_user_info(user, info)
    # Send an update to User1's profile
    # mixpanel_tracker.people.set('User1', {
    #     '$first_name' => 'David',
    #     '$last_name' => 'Bowie',
    #     'Best Album' => 'The Rise and Fall of Ziggy Stardust and the Spiders from Mars'
    # })
    mixpanel_tracker.people.set(user, info)
  end
end