module SearchHelper
  def self.filter_rooms(params)
    rooms = Array.new

    if params[:start_date] && params[:end_date]
      Room.all.each do |room|
        if BookingsHelper.is_bookable(room, Date.strptime(params[:start_date], '%Y.%m.%d'), Date.strptime(params[:end_date], '%Y.%m.%d'))
          rooms.push(room)
        end
      end
    end

    rooms #return
  end

  def filter_rooms(params)
    self.filter_rooms(params)
  end

end
