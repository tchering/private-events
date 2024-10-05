class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @events = Event.includes(:creator).all
  end

  def create
    @user = current_user
    @event = @user.created_events.new(event_params)
    if @event.valid?
      @event.save
      redirect_back(fallback_location: request.referer)
    else
      @events = @user.created_events
      @past_events = @user.participated_events.past_events || []
      @upcoming_events = @user.participated_events.upcoming_events || []
      render "users/show", status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:notice] = "The event #{@event.name} has been deleted"
      redirect_to user_path(current_user)
    else
      flash[:notice] = "Sorry event cannot be deleted"
      redirect_back
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def join
    @user = current_user
    @event = Event.find(params[:id])
    @join_event = UserEvent.new(user: @user, event: @event)
    if @event.creator == current_user
      flash[:notice] = "You cant join your own event"
    elsif UserEvent.exists?(user_id: current_user.id, event_id: @event.id)
      flash[:notice] = "You have already joined this event"
    elsif @join_event.valid?
      @join_event.save
      flash[:success] = "You have joined event #{@event.name}"
    else
      flash[:alert] = "Unable to join the event"
    end
    redirect_to event_path(@event)
  end

  def leave
    @event = Event.find(params[:id])
    @join_event = UserEvent.find_by(user_id: current_user.id, event_id: @event.id)
    if @join_event&.destroy
      redirect_to event_path(@event)
    else
      flash[:notice] = "Unable to leave this event "
      redirect_to event_path(@event)
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :location)
  end
end
