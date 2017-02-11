# HitList

Very simple and fast hit and popularity counter using Redis sorted sets.
It solves problem where you need to know most popular article or project in last X days.

[![Build Status](https://travis-ci.org/krists/hit_list.png?branch=master)](https://travis-ci.org/krists/hit_list)
[![Gem Version](https://badge.fury.io/rb/hit_list.png)](http://badge.fury.io/rb/hit_list)
[![Code Climate](https://codeclimate.com/github/krists/hit_list.png)](https://codeclimate.com/github/krists/hit_list)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hit_list'
```


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hit_list
    
## Usage with Rails

```ruby
# Set Redis connection in initializer
HitList::RailsModelExtension.redis_connection= Redis.new(host: '127.0.0.1', port: 6380)

# If you don't do this HitList will attempt to create one on its own with default arguments
# Equivalent to:
HitList::RailsModelExtension.redis_connection= Redis.new

# include in models..
class Article < ActiveRecord::Base
  include HitList::RailsModelExtension
  # ..
end

# Use..
Article.top_records(3) # => ["1", "43", "13"]

article = Article.first
article.total_hits # => 4
article.increment_hit_counter! # Increments total hits counter and ranking for days
article.increment_only_total_hits!
article.increment_only_rank!

# When you want to preserve rank stats for more than default 7 days you have to overwrite method hit_list_day_count
class Article < ActiveRecord::Base
  include HitList::RailsModelExtension

  def hit_list_day_count
    14
  end

  # ..

end
```

## Usage without Rails

```ruby
# connect to redis db
redis_connection = Redis.new(:host => "10.0.1.1", :port => 6380)

# pass connection when initializing counter
counter = HitList::Counter.new(connection, 'articles')

# make hits..
counter.hit!(2)
counter.hit!(2)
counter.hit!('bob')

# see results..
counter.total_hits(2) # => 2
counter.total_hits('bob') # => 1

# You can track hits on objects. Just provide different name
counter_1 = HitList::Counter.new(connection, 'articles')
counter_1.hit!('top-story')
counter_2 = HitList::Counter.new(connection, 'users')
counter_2.hit!('alice')

# Finaly you can see top records for any given time.
counter_1 = HitList::Counter.new(connection, 'articles')
counter_1.top_records(3) # => ["91","5","34"]

# or rankings 3 days ago..
counter_1.top_records(2, Time.now - 3.days) # => ["5","34"]
```

If you want to preserve ranking for more than 7 days you have to provide day count when initializing `HitList::Counter` object

```ruby
# Preserve rankings for 2 weeks
counter = HitList::Counter.new(connection, 'articles', 14)
counter.hit!('something')
```
