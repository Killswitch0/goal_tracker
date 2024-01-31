module ChartHelper
  def set_chart(tasks = nil, habits = nil, height: '400px')
    period = { 
      'day' => :day,
      'week' => :week,
      'month' => :month
    }.fetch(
        params[:period],
        :day
    )

    if current_page?(controller: 'charts', action: 'task')

      if tasks.pluck(:complete_date).all?(&:nil?)
        tasks = tasks.map do |task|
          {
            name: t.name,
            data: Array.new(task.length, {})
          }
        end

        line_chart(tasks, height:, locale: I18n.locale)
      else
        line_chart tasks.group(:name).group_by_period(period, :complete_date).count
      end
    else
      habits = habits.map do |habit|
        completion_data = habit.completion_dates.presence || {}
        empty_data = Array.new(habits.length, {})

        {
          name: habit.name,
          data: completion_data.empty? ? empty_data : completion_data.group_by_period(period, :date).count
        }
      end

      line_chart(habits, height:, locale: I18n.locale)
    end
  end

end
