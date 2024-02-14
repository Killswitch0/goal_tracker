module CalendarHelper
  def calendar_dates_range
    # Range for five years forward and five years ago
    start_year = Date.today.year - 5
    end_year = Date.today.year + 5
    (start_year..end_year).map { |year| [year, year] }
  end

  # helper for calendar
  # check in views/calendar/show
  def habits_for
    @habits
  end
end
