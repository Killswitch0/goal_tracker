module ChartHelper
  def set_chart(tasks = nil, habits = nil)
    period = { 'day' => :day,
               'week' => :week,
               'month' => :month
    }.fetch(params[:period], :day)

    if current_page?(controller: 'charts', action: 'task')

      if tasks.pluck(:complete_date).all?(&:nil?)
        line_chart(tasks.map do |t|
          {
            name: t.name,
            data: Array.new(tasks.length, {})
          }
        end)
      else
        line_chart tasks.group(:name).group_by_period(period, :complete_date).count
      end
    else
      line_chart(habits.map do |habit|
        completion_data = habit.completion_dates.presence || {}
        empty_data = Array.new(habits.length, {})

        {
          name: habit.name,
          data: completion_data.empty? ? empty_data : completion_data.group_by_period(period, :date).count
        }
      end)
    end
  end

  def chart_link_to(title, path, period)
    link_to title, path, class: "#{params[:period] == "#{period}" ?
                                     'btn btn-primary btn-sm' :
                                     'btn btn-outline-primary btn-sm'}"
  end
end
