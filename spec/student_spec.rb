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

  describe '#name' do
    it 'should return the name' do
      expect(student.name).to eq("Nikki")
    end
  end

  describe 'twitter' do
    it 'should return the twitter' do
      expect(student.twitter).to eq("http://twitter.com")
    end
  end

  describe 'blog' do
    it 'should return the blog' do
      expect(student.blog).to eq("http://blog.com")
    end
  end
end

# test for errors, test for returning blog and twitter and name