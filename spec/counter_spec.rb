require "spec_helper"

describe HotOrNot::Counter do
  let(:connection) { double "connection" }
  let(:name) { 'article' }
  let(:days_of_interest) { 7 }
  subject { described_class.new(connection, name, days_of_interest) }

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
end
