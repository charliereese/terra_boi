require "generators/extensions"

module TerraBoi
	class HostInitializerGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :class_options
	  class_option :domain_name, type: :string
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate host initializer rails file
		  
		  To execute, run rails generate terra_boi:host_initializer --domain_name example.com
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  	self.class_options = options
	  end

	  def create_host_initializer_file
	  	template "host_initializer.erb", "config/initializers/hosts.rb"
	  end
	end
end