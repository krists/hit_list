require "spec_helper"

describe HitList::Counter do
  let(:real_connection) { Redis.new }
  let(:name) { 'article' }
  let(:days_of_interest) { 7 }

  subject { described_class.new(real_connection, name, days_of_interest) }

  before(:each) do
    real_connection.flushall
  end

  describe "#total_hits" do
    it "works as expected" do
      Timecop.travel(Date.parse('2013-01-21'))
      subject.hit!(22)
      subject.hit!(22)
      subject.hit!(7)
      subject.hit!(44)
      subject.hit!(44)
      subject.hit!(44)
      expect(subject.total_hits(22)).to eq(2)
      expect(subject.total_hits(7)).to eq(1)
      expect(subject.total_hits(44)).to eq(3)
      Timecop.return
    end
  end

  describe "#top_records" do
    it 'top records should work' do
      Timecop.travel(Date.parse('2013-01-21'))
      subject.hit!(22)
      subject.hit!(22)
      subject.hit!(22)
      subject.hit!(7)
      Timecop.travel(Date.parse('2013-01-22'))
      subject.hit!(22)
      subject.hit!(22)
      Timecop.travel(Date.parse('2013-01-23'))
      subject.hit!(22)
      subject.hit!(7)
      subject.hit!(7)
      subject.hit!(7)
      subject.hit!(7)
      expect(subject.top_records(2)).to eq(["22", "7"])
      Timecop.travel(Date.parse('2013-01-25'))
      expect(subject.top_records(2)).to eq(["22", "7"])
      Timecop.travel(Date.parse('2013-01-28'))
      expect(subject.top_records(2)).to eq(["7", "22"])
      Timecop.return
    end
  end
end
