# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email:'admin@imob.com', name:'admin', password: 123456, role: 0)
User.create(email:'agent@imob.com', name:'agent', password: 123456, role: 1)
User.create(email:'customer@imob.com', name:'customer', password: 123456, role: 2)
