require "spec_helper"

describe HitList::RailsModelExtension do

  describe "#module methods" do
    subject { HitList::RailsModelExtension }
    describe "#redis_connection" do
      context "when not specifying any specific connection" do
        it "returns Redis connection with default configuration" do
          expect(subject.redis_connection).to be_a_kind_of(Redis)
        end
      end
    end

    describe "#redis_connection=" do
      it "allows to set Redis connection" do
        subject.redis_connection= 'fake connection'
        expect(subject.redis_connection).to eq('fake connection')
      end
    end
  end

  describe "Class with RailsModelExtension included" do

    SomethingModelish = Struct.new(:id) do
      include HitList::RailsModelExtension
    end

    describe "class methods" do
      subject { SomethingModelish }

      describe "#top_records" do
        it "calls counter top_records method" do
          expect_any_instance_of(HitList::Counter).to receive(:top_records).with(3)
          subject.top_records(3)
        end
      end
    end

    describe "instance methods" do
      subject { SomethingModelish.new(:the_id) }

      describe "#total_hits" do
        it "calls counter total_hits method with model id" do
          expect_any_instance_of(HitList::Counter).to receive(:total_hits).with(:the_id)
          subject.total_hits
        end
      end

      describe "#increment_hit_counter!" do
        it "calls counter hit! method with record id" do
          expect_any_instance_of(HitList::Counter).to receive(:hit!).with(:the_id)
          subject.increment_hit_counter!
        end
      end

      describe "#increment_only_total_hits!" do
        it "calls counter hit! method with record id" do
          expect_any_instance_of(HitList::Counter).to receive(:increment_total_hits!).with(:the_id)
          subject.increment_only_total_hits!
        end
      end

      describe "#increment_only_rank!" do
        it "calls counter hit! method with record id" do
          expect_any_instance_of(HitList::Counter).to receive(:increment_rank!).with(:the_id)
          subject.increment_only_rank!
        end
      end
    end
  end
end
