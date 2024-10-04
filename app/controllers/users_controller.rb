class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @events = current_user.created_events #is passed in users/show.html.erb
    @event = Event.new #is passed in users/show.html.erb to show form error.
    @past_events = @user.participated_events.past_events
    @upcoming_events = @user.participated_events.upcoming_events
  end
end
