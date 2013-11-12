exposed_factory
===============

Exposes your back-end (Rails) factories (Factory Girl) for client-side full-stack testing with (Ember) Javascript

Although this gem is designed to work with Rails, Factory Girl and Ember, it should be easy to use anywhere you have Rack, factories, and need full-stack testing with your API from a client.

## Usage


```javascript
// create the factory
f = ExposedFactory.create();

// add some strategies to the factory
f.add("user", "frank" { fullName: "Frank Sinatra" });
f.add("post", "post");
f.add("postWithComments", "anotherPost", { commentsCount: 15 });

// building the factory returns a promise
f.build().then(function(data){
  // `data` contains the built records from your strategies above
  data.get("frank.fullName") // => "Frank Sinatra"
  data.get("post.body") // => "My post body"
  data.get("anotherPost.comments.length") // => 15
})

```

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

