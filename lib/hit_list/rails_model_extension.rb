module HitList::RailsModelExtension

    def self.redis_connection
      @redis_connection ||= begin
        puts "HitList::RailsModelExtension: No Redis connection provided. Creating new with default settings"
        Redis.new
      end
    end

    def self.redis_connection=(connection)
      @redis_connection = connection
    end

    module ClassMethods
      def top_records(count = 5)
        counter = HitList::Counter.new(HitList::RailsModelExtension.redis_connection, self.name)
        counter.top_records(count)
      end
    end

    module InstanceMethods

      def hit_list_day_count
        7
      end

      def total_hits
        hit_counter.total_hits(self.id)
      end

      def increment_hit_counter!
        hit_counter.hit!(self.id)
      end

      def increment_only_total_hits!
        hit_counter.increment_total_hits!(self.id)
      end

      def increment_only_rank!
        hit_counter.increment_rank!(self.id)
      end

      def hit_counter
        @hit_counter ||= HitList::Counter.new(HitList::RailsModelExtension.redis_connection, self.class.name, hit_list_day_count)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
end
