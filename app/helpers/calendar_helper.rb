module CalendarHelper
  def calendar_dates_range
    # Допустим, что вы хотите предоставить диапазон на пять лет вперед и пять лет назад
    start_year = Date.today.year - 5
    end_year = Date.today.year + 5
    (start_year..end_year).map { |year| [year, year] }
  end
end
