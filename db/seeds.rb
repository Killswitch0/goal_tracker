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
user.habits.last(4).each { |habit| habit.complete_habit_today }
user.tasks.last(4).each { |task| task.update(complete: true) }










