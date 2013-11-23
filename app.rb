require'./lib/scraper'
require './lib/student'
require 'awesome_print'
require 'ruby-debug'
require 'launchy'

class StudentMaker
  attr_reader :scraper
  def initialize(url)
    @scraper = Scraper.new(url)
  end

  def scrape
    names = scraper.get_students_names
    twitters = scraper.get_students_twitters
    blogs = scraper.get_students_blogs
    students = []

    28.times do |i|
      student = Student.new(names[i], twitters[i], blogs[i])
      students << student
    end
    students
  end
end

class App
  attr_reader :students

  def initialize
    @students = StudentMaker.new("http://flatironschool-bk.herokuapp.com/").scrape
  end

  def lookup_message
    "Print a student's name to look up the student or random to get a random blog or twitter!"
  end

  def input
    gets.chomp
  end

  def get_student
    request = input
    # random if request == /r(andom)?/
    students.each do |student|
      if student.name == request
        student
      else
        "Please type in the name of a student."
        get_student
      end
    end
  end

  def blog_or_twitter(student)
    puts "Blog: #{student.blog}; Twitter: #{student.twitter}\nPrint b to open blog, t to open twitter."
  end

  def launch(student)
    case input
    when /b(log)?/
      Launchy.open(student.blog)
    when /t(witter)?/
      twitter = "http://twitter.com/" + student.twitter.gsub(/@/, "")
      Launchy.open(twitter)
    else
      "Print b to open blog, t to open twitter."
    end
  end

  def open_random
    array = [students.sample.blog, students.sample.twitter]
    Launchy.open("#{array.sample}")
  end

  def run
    puts lookup_message
    blog_or_twitter(get_student)
    debugger
    launch(student)
  end
end

app = App.new
app.run


#  - launches a given student's twitter

#  - launches a given student's blog

#  - launches a random student's twitter

#  - launches a random student's blog

# build whatever interface you want! i'm excited to see different implementations :)

