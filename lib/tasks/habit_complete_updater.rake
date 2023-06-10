namespace :habit_complete_updater do
  desc "TODO"
  task habit_updater: :environment do
    completed_habits = Habit.where(keep: true)

    completed_habits.each do |habit|
      CompletionDate.where(habit_id: habit.id).each do |complete|
        if complete.date.strftime('%d %m %Y') < (Time.now.localtime.strftime('%d %m %Y'))
          habit.update_attribute(:keep, false)
        end
      end
    end

  end

end
