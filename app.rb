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
    display welcome
    loop do
      name = name_lookup
      unless name == "random"
        blog_twitter(name)
        launch(name)
      end
      display rerun_message
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
      "Affirmative, Dave. I read you.\n\nPrint a student's name to look up the student;\nrandom to get a random blog or twitter;\ne to exit at any time."
    end

    def error
      "\nI can't find that student.\nIt can only be attributable to human error.\nEnter another name."
    end

    def name_lookup
      name = get_input

      case name
      when /^r(andom)?$/
        launch_random
        return "random"
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
      "Print b to launch blog, t to launch twitter, c to cancel."
    end

    def blog_twitter(student)
      display "\nBlog: #{student.blog} \nTwitter handle: #{student.twitter}\n\n"
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
        display "\nI'm sorry, Dave. I'm afraid I can't let you do that.\nI think you know what the problem is just as well as I do."
      end
    end

    def launch(student)
      display launch_message
      case get_input
      when "b"
        open(student.blog)
      when "t"
        open(get_twitter_url(student))
      when "c"
        return
      when "e"
        exit
      else
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
end

app = App.new("http://flatironschool-bk.herokuapp.com") 
app.run