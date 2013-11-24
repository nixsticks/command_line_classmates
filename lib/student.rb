class Student
  attr_reader :name, :first_name, :last_name, :twitter, :blog

  def initialize(name, first_name, last_name, twitter, blog)
    @name = name
    @first_name = first_name
    @last_name = last_name
    @twitter = twitter
    @blog = blog
  end
end