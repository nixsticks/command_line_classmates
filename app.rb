require'./lib/scraper'
require './lib/student'
require 'awesome_print'

my_scraper = Scraper.new("http://flatironschool-bk.herokuapp.com")
names = my_scraper.get_students_names
twitters = my_scraper.get_students_twitters
blogs = my_scraper.get_students_blogs

students = []

27.times do |i|
  student = Student.new(names[i], twitters[i], blogs[i])
  students << student
end