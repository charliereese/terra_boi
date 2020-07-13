require "generators/extensions"

module TerraBoi
	class TfStateGenerator < Rails::Generators::Base
		attr_accessor :application_name
		source_root File.expand_path('templates', __dir__)

		desc (<<-EOF
			Generate DB and S3 bucket for storing and locking terraform state
			
			To execute, run rails generate terra_boi:state
			EOF
			.gsub(/\t/, '')
		)

		def init
			self.application_name = generate_application_name
		end

		def create_main_terraform_file
			template "state_main.erb", "terraform_v2/state/main.tf"
		end
	end
end