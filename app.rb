require'./lib/scraper'
require './lib/student'
require 'launchy'


module StudentMaker
  def scrape(url)
    scraper = Scraper.new(url)
    names = scraper.get_students_names
    twitters = scraper.get_students_twitters
    blogs = scraper.get_students_blogs

    students = []

    28.times do |i|
      student = Student.new(names[i].downcase, twitters[i], blogs[i])
      students << student
    end

    students
  end
end

class App

  include StudentMaker

  attr_reader :students

  def initialize(url)
    @students = scrape(url)
  end

  def get_input
    gets.chomp.downcase
  end

  def display(message)
    puts message
  end

  def welcome
    "Print a student's name to look up the student or random to get a random blog or twitter!"
  end

  def error
    "Please enter the name of a student."
  end

  def name_lookup
    name = get_input

    case name
    when "random"
      launch_random
      name
    else
      students.each do |student|
        return student if student.name == name
      end
      display error
      name_lookup
    end
  end

  def launch_message
    "Print b to launch blog, t to launch twitter, e to exit."
  end

  def blog_twitter(student)
    display "\nBlog: #{student.blog} \nTwitter handle: #{student.twitter}\n\n"
    display launch_message
  end

  def url_exists(site)
    true unless site.split("/").include?("NA")
  end

  def get_twitter_url(student)
    twitter = student.twitter.gsub("@", "")
    "http://twitter.com/#{twitter}"
  end

  def open(url)
    Launchy.open(url) if url_exists(url)
  end

  def launch(student)
    case get_input
    when "b"
      open(student.blog)
    when "t"
      open(get_twitter_url(student))
    when "e"
      exit
    else
      display launch_message
      launch(student)
    end
  end

  def launch_random
    student = students.sample
    urls = [student.blog, get_twitter_url(student)]
    open(urls.sample)
  end

  def run
    display welcome
    name = name_lookup
    unless name == "random"
      blog_twitter(name)
      launch(name)
    end
  end
end

app = App.new("http://flatironschool-bk.herokuapp.com") 
app.run
