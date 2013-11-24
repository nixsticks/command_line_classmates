require_relative './lib/scraper'
require_relative './lib/student'
require 'awesome_print'
require 'launchy'


module StudentMaker
  def scrape(url)
    scraper = Scraper.new(url)
    names = scraper.get_students_names
    first_names = scraper.get_first_names
    last_names = scraper.get_last_names
    twitters = scraper.get_students_twitters
    blogs = scraper.get_students_blogs

    students = []

    28.times do |i|
      student = Student.new(names[i].downcase, first_names[i].downcase, last_names[i].downcase, twitters[i], blogs[i])
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

  def run
    loop do
      display welcome
      name = name_lookup
      unless name == "random"
        blog_twitter(name)
        launch(name)
      end
      display rerun_message
      rerun
      puts
    end
  end

  private
    def get_input
      gets.chomp.downcase
    end

    def display(message)
      puts message
    end

    def welcome
      "Affirmative, Dave. I read you.\n\nPrint a student's name to look up the student; random to get a random blog or twitter; e to exit at any time."
    end

    def error
      "\nI can't find that student. It can only be attributable to human error. Enter another name."
    end

    def name_lookup
      name = get_input

      case name
      when /^r(andom)?$/
        launch_random
        return name
      when /^e(xit)?$/
        exit
      else
        students.each do |student|
          return student if student.name == name || student.first_name == name || student.last_name == name
        end
      end
      display error
      name_lookup
    end

    def launch_message
      "Print b to launch blog, t to launch twitter."
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
      if url_exists(url)
        Launchy.open(url)
      else
        display "\nI'm sorry, Dave. I'm afraid I can't let you do that. I think you know what the problem is just as well as I do."
      end
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

    def rerun_message
      "\nLook up another student?"
    end

    def rerun
      case get_input
      when /^y(es)?$/
        return
      when /^no?$/
        exit
      when /^e(xit)?$/
        exit
      else
        display "Please type yes or no."
        rerun
      end
    end
end

app = App.new("http://flatironschool-bk.herokuapp.com") 
app.run