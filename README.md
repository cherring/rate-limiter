## Rate Limiter Example.

### To get running

- Install Ruby version 2.4.0, specified in .ruby-version if required
- Install Bundler for Ruby verion if required
- bundle install
- bundle exec db:create
- bundle exec db:migrate

### The Code

Is contained in app/controllers/home_controller.rb and app/models/request.rb and app/models/rate_limit.rb

### The tests

Are written in rspec. To run them, bundle exec rspec spec/

To read them, they are spec/requests/home_controller_spec.rb, spec/models/request_spec.rb and spec/models/rate_limit_spec.rb
