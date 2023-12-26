# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |n|
  name = Faker::Games::Pokemon.name
  email = Faker::Internet.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               )
end

user = User.first
10.times do |n|
  title = "task_#{n}"
  Task.create!(title: title,
               deadline_on: "002023-12-1#{n}",
               user_id: user.id,
               )
end

clients_name = ["〇〇株式会社", "〇〇社", "〇〇商事", "〇〇（株）", "有限会社〇〇"]
clients_name.each do |client_name|
  Client.create!(name: client_name)
end

type_of_tasks_name = ["上質紙", "A紙", "B紙", "地巻紙", "四つ切"]
type_of_tasks_name.each do |type_name|
  TypeOfTask.create!(name: type_name)
end
