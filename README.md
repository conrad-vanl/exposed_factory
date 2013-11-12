exposed_factory
===============

Exposes your back-end (Rails) factories (Factory Girl) for client-side full-stack testing with (Ember) Javascript

Although this gem is designed to work with Rails, Factory Girl and Ember, it should be easy to use anywhere you have Rack, factories, and need full-stack testing with your API from a client.

## Usage

Lets say you use factory girl and have the following factories:

```ruby
# my_factories.rb
factory :post do
  body "My post body"
  title "Some title"
end
  
factory :user do
  fullName "John Doe"
end
```

Once exposed_factory is setup in your backend, you have a simple api that you can utlize in your client-side javascript integration tests:

```javascript
// myIntegrationTest.js

// create the factory
f = ExposedFactory.create();

// add some strategies to the factory
f.add("user", "frank" { fullName: "Frank Sinatra" });
f.add("post", "post");

// building the factory connects to your Rails app, 
// runs the strategies that you added (above), and returns an Ember-style 
// promise that is fullfilled once everything has finished
f.build().then(function(data){
  // `data` contains the built records from your strategies above
  // data.get("frank.fullName") == "Frank Sinatra"
  // data.get("post.body") // == "My post body"
})

```

For a more complete example of an integration test, see this gist: https://gist.github.com/conrad-vanl/4abdedddfe2503dfc3d9

## Basic Setup

### Rails 

include the gem in your development group in your `Gemfile`:

```ruby
group :test do
  gem "exposed_factory",          :github => "https://github.com/conrad-vanl/exposed_factory"
end
```

tell Rails to use exposed_factory as middleware in `config/environments/test.rb`:

```ruby
config.middleware.use Rack::ExposedFactory
```

then start Rails in test env:

```bash
$ rails server -e test
```
