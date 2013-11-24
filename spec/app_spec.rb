require '../app.rb'

describe App do
  let(:app) {App.new("http://flatironschool-bk.herokuapp.com")}

  describe '#initialize' do
    it 'should return an array of students' do
      expect(app.students).to be_a_kind_of(Array)
    end
  end

  context 'when random is entered' do    
    describe '#run' do
      it 'should launch a random site' do
        app.stub(:get_input) {"random"}
        app.stub(:launch_random) {"Random site launched"}

        expect(app.run).to eq("random")
      end
    end
  end

  context 'when a student name is entered' do
    describe '#run' do
      it 'should launch a student blog when b is selected' do
        app.stub(:get_input).and_return("Anisha Ramnani", "b")
        app.stub(:open) {"Site opened"}

        expect(app.run).to eq("Site opened")
      end

      it 'should launch a student twitter when t is selected' do
        app.stub(:get_input).and_return("Sarah Ransohoff", "t")
        app.stub(:open) {"Site opened"}

        expect(app.run).to eq("Site opened")
      end

      it 'should not launch for a nonexistent blog or twitter' do
        app.stub(:get_input).and_return("Nikki Thean", "t")
        app.stub(:url_exists) {"No site"}

        expect(app.run).to eq("No site")
      end
    end
  end
end