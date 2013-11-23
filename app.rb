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
    display "Print a student's name to look up the student or random to get a random blog or twitter!"
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
      display "Please enter the name of a student."
      name_lookup
    end
  end

  def blog_twitter(student)
    display "\nBlog: #{student.blog} \nTwitter: #{student.twitter} \n\nPrint b to launch blog, t to launch twitter, e to exit."
  end

  def url_exists(site)
    true unless site == "NA"
  end

  def launch(student)
    case get_input
    when "b"
      Launchy.open("#{student.blog}") if url_exists(student.blog)
    when "t"
      twitter_url = student.twitter.gsub("@", "")
      Launchy.open("http://twitter.com/#{twitter_url}") if url_exists(student.twitter)
    when "e"
      exit
    else
      display "Print b to launch blog, t to launch twitter, e to exit."
      launch(student)
    end
  end

  def launch_random
    student = students.sample
    blog = student.blog if url_exists(student.blog)
    twitter = "http://twitter.com/" + student.twitter.gsub("@", "") if url_exists(student.twitter)
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
