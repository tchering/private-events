class UserEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @join_event = UserEvent.new(user: current_user, event: @event)
    if @event.creator == current_user
      flash[:notice] = "You can't join your own event"
    elsif UserEvent.exists?(user: current_user, event: @event)
      flash[:notice] = "You have already joined this event"
    elsif @join_event.valid?
      @join_event.save
      flash[:notice] = "You have joined #{@event.name} event."
    else
      flash[:alert] = "Unable to join the event."
    end
    redirect_to user_event_path(current_user, @event)
  end

  def destroy
    @event = Event.find(params[:event_id])
    @join_event = UserEvent.find_by(user: current_user, event: @event)
    if @join_event&.destroy
      flash[:notice] = "You have left the #{@event.name} event."
    else
      flash[:alert] = "Unable to leave the event."
    end
    redirect_to event_path(@event)
  end
end
