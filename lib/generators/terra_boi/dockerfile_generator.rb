require "generators/extensions"

module TerraBoi
	class DockerfileGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :class_options
	  class_option :ruby_version, type: :string, default: "2.5.1"
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate Dockerfile for rails app
		  
		  To execute, run rails generate terra_boi:dockerfile

		  Can pass in --ruby_version command line argument. Defaults to 2.5.1.
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	self.application_name = generate_application_name
	  	self.class_options = options
	  end

	  def create_dockerfile
	  	template "Dockerfile.erb", "Dockerfile"
	  end
	end
end