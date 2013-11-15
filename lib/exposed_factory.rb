require "rack/exposed_factory"

if !!Rails
  ActiveRecord::Base.send(:define_method, :include_in_exposed_factory) do 
    @include_in_exposed_factory
  end
  ActiveRecord::Base.send(:define_method, :include_in_exposed_factory=) do |arg| 
    @include_in_exposed_factory = arg
  end
end