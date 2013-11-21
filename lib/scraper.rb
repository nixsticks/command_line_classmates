require 'open-uri'
require 'nokogiri'

class Scraper
  attr_reader :html

  def initialize(url)
    @html = Nokogiri::HTML(open(url))
  end

  def get_students_names
    # html.search("h3").text.scan(/[A-Z][a-z]* [A-Z]'?[A-Z]?[a-z]*/)
    html.search("h3").text.split(/(?<=[a-z.])(?=[A-Z])/)
  end

  def get_students_twitter
    html.css(".twitter").text.split
  end

  def get_students_blogs
    html.search(".blog").map {|link| link['href']}
  end
end

my_scraper = Scraper.new("http://flatironschool-bk.herokuapp.com")
puts my_scraper.get_students_names
puts my_scraper.get_students_twitter
puts my_scraper.get_students_blogs