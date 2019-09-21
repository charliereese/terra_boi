require "generators/extensions"

module TerraBoi
	class StateGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :class_options
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate DB and S3 bucket for storing and locking terraform state
		  
		  To execute, run rails generate terra_boi:state
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	self.application_name = generate_application_name
	  	self.class_options = options
	  end

	  def create_main_terraform_file
	  	template "state_main.erb", "terraform/state/main.tf"
	  end
	end
end