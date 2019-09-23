require "generators/extensions"

module TerraBoi
	class PackerGenerator < Rails::Generators::Base
	  attr_accessor :application_name
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate packer files for building AWS EC2 AMI
		  
		  To execute, run rails generate terra_boi:packer
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  end

	  def create_packer_files
	  	template "packer_ami_build.erb", "packer/ami_build.sh"
	  	template "packer_application.erb", "packer/application.json"
	  end
	end
end