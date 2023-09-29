# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# User.create(name: "Max", email: "t@t.com", password: "111111", password_confirmation: "111111")
# Category.create(name: "Sport")

# db/seeds.rb

# Create user
user = User.create(
  name: "Walter",
  email: "walt@mail.com",
  password: "111111a",
  email_confirmed: true,
  role: 1
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

challenge = Challenge.create(
  name: 'Who the best?',
  description: 'We need to know who the best',
  user_id: user.id
)

ChallengeUser.create(
  user_id: user.id,
  challenge_id: challenge.id
)

# Create 10 habits
10.times do |i|
  Habit.create(
    name: "Morning exercise #{i}",
    description: "Exercise for 30 minutes every morning.",
    user_id: user.id,
    goal_id: goal.id,
    created_at: Date.today.beginning_of_year,
    updated_at: Date.today.beginning_of_year
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

start_date = Date.new(2023, 1, 1)

(0..6).each do |offset|
  date = start_date + offset.months
  CompletionDate.create(date: date, habit_id: 1, created_at: date, updated_at: date)
end

(0..6).each do |offset|
  date = start_date + offset.months + 1.month
  CompletionDate.create(date: date, habit_id: 2, created_at: date, updated_at: date)
end

(0..6).each do |offset|
  date = start_date + offset.months + 2.months
  CompletionDate.create(date: date, habit_id: 3, created_at: date, updated_at: date)
end










