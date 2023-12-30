# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#   User.create(name: "Max", email: "t@t.com", password: "111111", password_confirmation: "111111")
#   Category.create(name: "Sport")

# db/seeds.rb

# Create user
user = User.create(
  name: "Walter",
  email: "walt@mail.com",
  password: "111111a",
  email_confirmed: true,
  role: 1
)

user2 = User.create(
  name: 'Dennis',
  email: 'den@mail.com',
  password: '111111b',
  email_confirmed: true
)

# Create category
category = Category.create(name: "Health", user_id: user.id)

# Create goal
goal = Goal.create(
  name: "Exercise regularly",
  description: "Stay fit and healthy",
  color: 'Purple',
  deadline: Date.today + 2.weeks,
  user_id: user.id,
  category_id: category.id
)

# Create challenge
challenge = Challenge.create(
  name: 'Who the best?',
  description: 'We need to know who the best',
  user_id: user.id, 
  deadline: Date.today + 3.days
)

challenge2 = Challenge.create(
  name: 'Who the biggest man in the world?',
  description: 'Wee need to know!',
  user_id: user2.id,
  deadline: Date.today + 3.days
)

ChallengeUser.create(
  user_id: user.id,
  challenge_id: challenge.id,
  confirm: true
)

ChallengeUser.create(
  user_id: user2.id,
  challenge_id: challenge2.id
)

ChallengeUser.create(
  user_id: user.id,
  challenge_id: challenge2.id
)

# Create 10 habits
10.times do |i|
  Habit.create(
    name: "Morning exercise #{i}",
    description: "Exercise for 30 minutes every morning.",
    user_id: user.id,
    goal_id: goal.id
  )
end

# Create 10 tasks
10.times do |i|
  Task.create(
    name: "Buy groceries #{i}",
    user_id: user.id,
    goal_id: goal.id,
    deadline: Date.today + i.weeks
  )
end

# Complete 4 habits and tasks
user.tasks.last(4).each { |task| task.update(complete: true) }


# Create habits completions
habit = Habit.create(
  name: 'Drink morning water',
  description: 'Drink water 30 minutes after waking up',
  user_id: user.id,
  goal_id: goal.id,
  created_at: Date.today - 6.weeks,
  updated_at: Date.today - 6.weeks
)

completion_dates_data_habit = [
  { date_offset: (2.weeks + 3.days) },
  { date_offset: (2.weeks + 1.days) },
  { date_offset: (1.week + 5.days) },
  { date_offset: (1.week + 2.days) }
]

completion_dates_data_habit.each do |completion_date_params|
  CompletionDate.create(
    date: Date.today - completion_date_params[:date_offset],
    habit_id: habit.id,
    created_at: Date.today - completion_date_params[:date_offset],
    updated_at: Date.today - completion_date_params[:date_offset]
  )
end


habit2 = Habit.create(
  name: 'Take vitamins after breakfast',
  description: 'GNC MAN COMPLEX',
  user_id: user.id,
  goal_id: goal.id,
  created_at: Date.today - 7.weeks,
  updated_at: Date.today - 7.weeks
)

completion_dates_data = [
  { date_offset: (2.weeks + 3.days) },
  { date_offset: (1.week + 4.days) },
  { date_offset: 1.week },
  { date_offset: 4.days }
]

completion_dates_data.each do |completion_date_params|
  CompletionDate.create(
    date: Date.today - completion_date_params[:date_offset],
    habit_id: habit2.id,
    created_at: Date.today - completion_date_params[:date_offset] + 1.day, 
    updated_at: Date.today - completion_date_params[:date_offset] + 1.day
  )
end


# Create Tasks with complete_date
tasks_data = [
  { name: "Buy protein GNC", deadline_offset: 5.weeks, complete_offset: 4.weeks },
  { name: "Buy protein ON NUTRITION", deadline_offset: 7.weeks, complete_offset: (3.weeks + 5.days) },
  { name: "Buy protein BSN", deadline_offset: 7.weeks, complete_offset: (3.weeks + 2.days) },
  { name: "Buy protein WHEY SUPER", deadline_offset: 7.weeks, complete_offset: (3.weeks + 1.days) },
  { name: "Buy protein HYPER MUSCLE", deadline_offset: 7.weeks, complete_offset: (2.weeks + 5.days) },
  { name: "Buy protein MEGA MUSCLE", deadline_offset: 7.weeks, complete_offset: (2.weeks + 2.days) }
]

tasks_data.each do |task_params|
  Task.create(
    name: task_params[:name],
    user_id: user.id,
    goal_id: goal.id,
    deadline: Date.today + task_params[:deadline_offset],
    complete_date: Date.today - task_params[:complete_offset],
    created_at: Date.today - 5.weeks,
    updated_at: Date.today - 5.weeks
  )
end











