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
  spec.summary     = "Terraform infrastructure generators for AWS and Rails."
  spec.description = "The TerraBoi gem contains rails generators to create Terraform infrastructure as code. The generators create infrastructure code for load balancing / auto scaling / zero-downtime deployments, (rails) web apps (EC2 instances), DBs, and S3 buckets."
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

  spec.add_development_dependency "rails", "~> 6.0.0"
end
