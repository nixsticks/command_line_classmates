class Student
  attr_accessor :name, :first_name, :twitter, :blog

  def initialize(name, first_name, twitter, blog)
    @name = name
    @first_name = first_name
    @twitter = twitter
    @blog = blog
  end
end