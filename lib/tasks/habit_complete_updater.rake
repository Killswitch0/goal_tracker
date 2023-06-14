namespace :habit_complete_updater do
  desc "TODO"
  task habit_updater: :environment do
    completed_habits ||= Habit.where(completed: true)

    completed_habits.each do |habit|
      if habit.updated_at.localtime.strftime('%d %m %Y') < (Time.now.localtime.strftime('%d %m %Y')) &&
        habit.completed_today?
        habit.update_attribute(:completed, false)
      end
    end
  end
end
