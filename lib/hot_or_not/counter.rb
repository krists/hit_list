module HotOrNot
  class Counter
    DEFAULT_NAMESPACE = 'hot_or_not'
    SECONDS_IN_DAY = 86400
    DATE_PARTIAL_FORMAT = "%Y-%m-%d"
    DEFAULT_INCR_VALUE = 1

    def initialize(connection, name, days_of_interest)
      @connection, @name, @days_of_interest = connection, name, days_of_interest
    end

    attr_reader :namespace, :connection, :name, :days_of_interest

    def namespace
      DEFAULT_NAMESPACE
    end

    def total_hits(id)
      connection.get("#{namespace}:#{name}:total:#{id}")
    end

    def top_records(limit)
      date = Time.now.strftime(DATE_PARTIAL_FORMAT)
      connection.zrevrange("#{namespace}:#{name}:date:#{date}", 0, limit - 1)
    end

    def hit!(id)
      increment_total_hits!(id)
      increment_rank!(id)
    end

    def increment_total_hits!(id)
      connection.incr("#{namespace}:#{name}:total:#{id}")
    end

    def increment_rank!(id)
      @connection.pipelined do
        date_partials.each do |date_partial|
          connection.zincrby("#{namespace}:#{name}:date:#{date_partial}", DEFAULT_INCR_VALUE, id)
        end
      end
    end

    private

    def date_partials
      partials = []
      0.upto(days_of_interest) do |index|
        partials << (Time.now + (index * SECONDS_IN_DAY)).strftime(DATE_PARTIAL_FORMAT)
      end
      partials.to_enum
    end
  end
end
