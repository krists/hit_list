require "spec_helper"

describe HitList::Counter do
  let(:connection) { double "connection" }
  let(:name) { 'article' }
  let(:days_of_interest) { 7 }

  subject { described_class.new(connection, name, days_of_interest) }

  before(:each) do
    connection.stub(:get) { '' }
    connection.stub(:incr) { '' }
    connection.stub(:zincrby) { '' }
    connection.stub(:pipelined).and_yield
  end

  describe "#initialize" do
    it "requires connection, name and days of interest as arguments" do
      expect { subject }.not_to raise_error
    end
  end

  describe "#namespace" do
    it "returns default namespace for counter keys" do
      subject.namespace.should eq("hot_or_not")
    end
  end

  describe "#total_hits" do
    it "calls #get to connection with key like '<namespace>:<name>:total:<id>'" do
      connection.should_receive(:get).with('hot_or_not:article:total:12')
      subject.total_hits(12)
    end
  end

  describe "#hit!" do
    it "calls #increment_total_hits!" do
      subject.should_receive(:increment_total_hits!).with(13)
      subject.hit!(13)
    end
    it "calls #increment_rank!" do
      subject.should_receive(:increment_rank!).with(13)
      subject.hit!(13)
    end
  end

  describe "#increment_total_hits!" do
    it "calls #incr to connection with key like '<namespace>:<name>:total:<id>'" do
      connection.should_receive(:incr).with('hot_or_not:article:total:14')
      subject.increment_total_hits!(14)
    end
  end

  describe "#increment_rank!" do
    it "calls #zincrby on connection with key like '<namespace>:<name>:date:<date>:<id>' multiple times with right dates" do
      Timecop.freeze(Date.parse('2013-07-29')) do
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-07-29", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-07-30", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-07-31", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-08-01", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-08-02", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-08-03", 1, 66)
        connection.should_receive(:zincrby).with("hot_or_not:article:date:2013-08-04", 1, 66)
        subject.increment_rank!(66)
      end
    end
  end

  describe "#top_records" do
    context "when time not specified" do
      it "should get top records in period" do
        Timecop.freeze(Date.parse('2013-07-29')) do
          connection.should_receive(:zrevrange).with("hot_or_not:article:date:2013-07-29", 0, 4)
          subject.top_records(5)
        end
      end
    end

    context "when time is specified" do
      it "should get top records in period" do
        Timecop.freeze(Date.parse('2013-07-29')) do
          connection.should_receive(:zrevrange).with("hot_or_not:article:date:2013-02-22", 0, 2)
          subject.top_records(3, Date.parse('2013-02-22'))
        end
      end
    end
  end
end
