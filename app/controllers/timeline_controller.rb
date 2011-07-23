class TimelineController < ApplicationController

  def index
    @events = ActiveSupport::OrderedHash.new.tap do |events|
      Event.all(:order => "updated_at DESC", :limit => 50).each do |event|
        date = event.updated_at.to_date
        (events[date] ||= []) << event
      end
    end
  end
end
