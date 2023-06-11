namespace :habit_complete_updater do
  desc "TODO"
  task habit_updater: :environment do
    completed_habits ||= Habit.where(keep: true)

    completed_habits.each do |habit|
      if habit.updated_at.localtime.strftime('%d %m %Y') < (Time.now.localtime.strftime('%d %m %Y'))
        habit.update_attribute(:keep, false)
      end
    end
  end

end
