$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "terra_boi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "terra_boi"
  spec.version     = TerraBoi::VERSION
  spec.authors     = ["Charlie Reese"]
  spec.email       = ["j.charles.reese@gmail.com"]
  spec.homepage    = "https://github.com/charliereese/terra_boi"
  spec.summary     = "Deploy your rails application to AWS with `rake deploy`. terra_boi generates AWS infrastructure as code, provisions AWS infrastructure, and then deploys your application to it using Terraform, rails generators, and rake tasks."
  spec.description = """Deploy your rails application to AWS with `rake deploy`.

This ruby / rails gem was created by Charlie Reese (charliereese.ca/about) for Clientelify. It creates AWS infrastructure for your rails application and deploys it in 5 steps (3 installation steps and 2 rake tasks). It is free to use.

Out of the box, terra_boi provides remote state locking, load-balancing, simple scaling, zero-downtime deployments, CloudWatch logging, DBs, and S3 buckets for multiple infrastructure environments: by default, terra_boi creates staging and prod environments for your web app."""
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency "rails", '~> 6.0', '>= 6.0.0'
  spec.add_runtime_dependency "colorize"
  spec.add_dependency 'pg'
end
