# Rack::Middleware::QueryTracer

Dumps SQL queries with their positions in the source code.  For debugging purposes.

ex:

```
[QueryTracing] [/manage/users?utf8=%E2%9C%93&id=&code=&nickname=a&udid=&commit=Search] [QueryTracer] [/app/views/manage/users/_users_list.html.slim:16:in `_app_views_manage_users__users_list_html_slim__2039225012774348846_70304982918140'] SELECT COUNT(*) FROM `users`  WHERE (nickname LIKE 'a%')
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-middleware-query_tracer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-middleware-query_tracer

## Usage

(Rails app) Create config/initializers/query_tracer.rb as follows:

```
Rails.application.config.middleware.use Rack::Middleware::QueryTracer, Rails.logger if Rails.env.development?
```

(non-Rails app) Not tested. Patches are welcome.

## Credits

@mitaku

## Contributing

1. Fork it ( https://github.com/knagano/rack-middleware-query_tracer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
