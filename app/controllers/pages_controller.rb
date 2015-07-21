class PagesController < ApplicationController
  layout "website"

  def home
    track_event(current_user, 'visited home')
  end
end