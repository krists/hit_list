module HitList
  class Counter
    DEFAULT_NAMESPACE = 'hit_list'
    DEFAULT_DAYS_OF_INTEREST = 7
    SECONDS_IN_DAY = 86400
    DATE_PARTIAL_FORMAT = "%Y-%m-%d"
    DEFAULT_INCR_VALUE = 1

    # Creates new instance of counter. It requires a working Redis connection as first argument.
    #
    # ==== Examples
    #
    #   counter = HitList::Counter.new(connection, 'articles', 7)
    #   counter = HitList::Counter.new(connection, 'articles')
    def initialize(connection, name, days_of_interest = DEFAULT_DAYS_OF_INTEREST)
      @connection, @name, @days_of_interest = connection, name, days_of_interest
    end

    attr_reader :namespace, :connection, :name, :days_of_interest

    # Returns namespace used in keys
    def namespace
      DEFAULT_NAMESPACE
    end

    # Returns integer representing total hit count for specific id
    #
    # ==== Examples
    #
    #   counter.total_hits(5) # => 12
    #   counter.total_hits('some-slug') # => 3
    def total_hits(id)
      connection.get("#{namespace}:#{name}:total:#{id}").to_i
    end

    # Returns array of ids sorted by most hits first
    #
    # ==== Examples
    #
    #   counter.top_records(3) # => ["31", "1", "44"]
    #   counter.top(1, Time.now - 4.days) # => ["5"]
    def top_records(limit, time_of_interest = nil)
      time = time_of_interest || Time.now
      date = time.strftime(DATE_PARTIAL_FORMAT)
      connection.zrevrange("#{namespace}:#{name}:date:#{date}", 0, limit - 1)
    end

    # Increments total hits and rank for given id
    def hit!(id)
      increment_total_hits!(id)
      increment_rank!(id)
    end

    # Increments total hits only for given id
    def increment_total_hits!(id)
      connection.incr("#{namespace}:#{name}:total:#{id}")
    end

    # Increments rank only for given id
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
      now = Time.now
      0.upto(days_of_interest - 1) do |index|
        partials << (now + (index * SECONDS_IN_DAY)).strftime(DATE_PARTIAL_FORMAT)
      end
      partials.to_enum
    end
  end
end
