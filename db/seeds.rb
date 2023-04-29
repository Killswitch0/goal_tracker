# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(name: "Max", email: "t@t.com", password: "111111", password_confirmation: "111111")
Category.create(name: "Sport")

20.times do |i|
  puts "#{i}"

  Goal.create(name: "Goal #{i + 1}",
              description: "Description #{i + 1}",
              days_completed: 0,
              user_id: User.first.id,
              category_id: Category.first.id,
              deadline: "#{Date.new(2025, 2, 25)}"
  )
end

10.times do
  20.times do |i|
    Habit.create(name: "Habit #{i}",
                 description: "Description #{i}",
                 days_completed: 0,
                 user_id: User.first.id,
                 goal_id: i
    )
  end
end







