require_relative '../lib/student'

describe Student do
  let(:student) {Student.new("Nikki", "http://twitter.com", "http://blog.com")}
  describe '#initialize' do
    it 'should initialize with name, twitter, and blog' do
      expect(student.name).to be_a(String)
      expect(student.twitter).to be_a(String)
      expect(student.blog).to be_a(String)
    end
  end

  describe '#attr_accessors' do
    it 'should allow you to read the instance variables' do
      expect(student.name).to eq("Nikki")
    end

    it 'should allow you to write the instance variables' do
      student.blog = "So blog"
      expect(student.blog).to eq("So blog")
    end
  end
end