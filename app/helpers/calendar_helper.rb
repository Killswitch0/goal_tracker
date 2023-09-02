module CalendarHelper
  def calendar_dates_range
    # Допустим, что вы хотите предоставить диапазон на пять лет вперед и пять лет назад
    start_year = Date.today.year - 5
    end_year = Date.today.year + 5
    (start_year..end_year).map { |year| [year, year] }
  end

  # helper for calendar
  # check in views/calendar/show
  def habits_for
    @habits.left_outer_joins(:completion_dates)
           .where(completion_dates: { id: nil }) | @habits.left_joins(:completion_dates)
                                                          .where.not(completion_dates: { id: nil })
  end
end
