module ChartHelper
  def set_chart(tasks = nil, habits = nil)
    period = if params[:period] == 'day'
               :day
             elsif params[:period] == 'week'
               :week
             elsif params[:period] == 'month'
               :month
             else
               :day
             end

    if current_page?(controller: 'charts', action: 'task')

      if tasks.pluck(:complete_date).all? { |d| d.nil? }
        line_chart tasks.map { |t|

          {
            name: t.name,
            data: Array.new(tasks.length, {})
          }
        }
      else
        line_chart tasks.group(:name).group_by_period(period, :complete_date).count
      end
    else
      line_chart habits.map { |goal|
        completion_data = goal.completion_dates.presence || {}
        empty_data = Array.new(habits.length, {})

        {
          name: goal.name,
          data: completion_data.empty? ? empty_data : completion_data.group_by_period(period, :date).count
        }
      }
    end
  end

  def chart_link_to(title, path, period)
    link_to title, path, class: "#{params[:period] == "#{period}" ?
                                     'btn btn-primary btn-sm' :
                                     'btn btn-outline-primary btn-sm'}"
  end
end
