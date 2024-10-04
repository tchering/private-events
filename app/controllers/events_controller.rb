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
      redirect_to user_path(current)
    else
      flash[:notice] = "Sorry event cannot be deleted"
      redirect_back
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :location)
  end
end
