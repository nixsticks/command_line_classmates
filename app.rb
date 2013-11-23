require'./lib/scraper'
require './lib/student'
require 'awesome_print'
require 'ruby-debug'
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

  def welcome
    display "Print a student's name to look up the student or random to get a random blog or twitter!"
  end

  def get_input
    gets.chomp.downcase
  end

  def display(message)
    puts message
  end

  def name_lookup
    name = get_input

    case name
    when /r(andom)?/
      launch_random
      "random"
    else
      students.each do |student|
        return student if student.name == name
      end
      display "Please enter the name of a student."
      name_lookup
    end
  end

  def blog_twitter(student)
    display "Blog: #{student.blog}, twitter: #{student.twitter}. Print b to launch blog, t to launch twitter."
  end

  def check_url(site)
    true unless site == "NA"
  end

  def launch(student)
    case get_input
    when /b(log)?/
      Launchy.open("#{student.blog}") if check_url(student.blog)
    when /t(witter)?/
      twitter_url = student.twitter.gsub("@", "")
      Launchy.open("http://twitter.com/#{twitter_url}") if check_url(student.twitter)
    else
      display "Please print b or t."
      launch
    end
  end

  def launch_random
    student = students.sample
    blog = student.blog if check_url(student.blog)
    twitter = "http://twitter.com/" + student.twitter.gsub("@", "") if check_url(student.twitter)
    Launchy.open("#{[blog, twitter].compact.sample}")
  end

  def run
    welcome
    name = name_lookup
    unless name == "random"
      blog_twitter(name)
      launch(name)
    end
  end
end

app = App.new("http://flatironschool-bk.herokuapp.com")
app.run
