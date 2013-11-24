require 'awesome_print'
require 'open-uri'
require 'nokogiri'
require 'ruby-debug'

class Scraper
  attr_reader :html

  def initialize(url)
    @html = Nokogiri::HTML(open(url))
  end

  def get_students_names
    html.search("h3").map {|name| name.text}
  end

  def get_first_names
    names = html.search("h3").map {|name| name.text}
    names.map do |name|
      first_name = /^(\w+\b)/.match(name)
      first_name[0]
    end
  end

  def get_students_twitters
    html.css(".back").collect do |twitter|
      handle = twitter.search(".twitter")
      handle.empty? || handle.nil? ? "NA" : handle.text.gsub(/\s+/, "")
    end
  end

  def get_students_blogs
    html.search(".back").collect do |blog|
      blog = blog.search(".blog")
      blog.empty? || blog.nil? ? "NA" : blog.first['href']
    end
  end
end