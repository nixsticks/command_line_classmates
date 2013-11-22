require_relative '../lib/scraper.rb'

describe Scraper do
  let(:scraper) {Scraper.new("http://flatironschool-bk.herokuapp.com")}

  describe '#initialize' do
    it 'should initialize a scraper with a Nokogiri item' do
      expect(scraper.html).to be_a_kind_of(Nokogiri::HTML::Document)
    end
  end

  describe '#get_students_names' do
    let(:names) {scraper.get_students_names}

    it 'should return an array of the names of all the students' do
      expect(names).to be_a_kind_of(Array)
      expect(names.size).to eq(28)
    end

    it 'should contain the names of students in the class' do
      expect(names).to include('Nikki Thean')
    end
  end

  describe '#get_students_twitters' do
    let(:twitters) {scraper.get_students_twitters}

    it 'should return an array of the twitters of all the students' do
      expect(twitters).to be_a_kind_of(Array)
    end

    it 'should contain the twitter handles of students in the class' do
      expect(twitters).to include('@sranso')
    end
  end

  describe '#get_students_blogs' do
    let(:blogs) {scraper.get_students_blogs}

    it 'should return an array of the blogs of all the students' do
      expect(blogs).to be_a_kind_of(Array)
    end

    it 'should contain the blog urls of students in the class' do
      expect(blogs).to include("http://blurredcommandlines.tumblr.com/")
    end
  end
end