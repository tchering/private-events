class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @events = @user.created_events.includes(:creator) #is passed in users/show.html.erb
    @event = Event.new #is passed in users/show.html.erb to show form error.
    @past_events = @user.participated_events.past_events.includes(:creator)
    @upcoming_events = @user.participated_events.upcoming_events.includes(:creator)
  end
end
