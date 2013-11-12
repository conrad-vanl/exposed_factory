lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exposed_factory/version"

Gem::Specification.new do |s|
  s.name = "exposed_factory"
  s.version = ExposedFactory::VERSION
  s.authors = ["Conrad VanLandingham", "CrowdHall.com"]
  s.email = "conrad@crowdhall.com"
  s.summary = "Exposes your Rails factories for client-side full stack testing with Javascript"

  s.files = `git ls-files`.split("\n")
end