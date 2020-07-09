require "generators/extensions"

module TerraBoi
	class LibGenerator < Rails::Generators::Base
		attr_accessor :application_name
		source_root File.expand_path('templates', __dir__)

		desc (<<-EOF
			Generate lib directory with templates, scripts, and modules for deploying application containers to AWS ECS
			
			To execute, run rails generate terra_boi:lib
			EOF
			.gsub(/\t/, '')
		)

		def init
			# defined in lib/generators/extensions
			self.application_name = generate_application_name
		end

		def create_ecr
			template "lib/scripts/push_to_ecr.sh.erb", "terraform_v2/lib/scripts/push_to_ecr.sh"
			template "lib/scripts/update_service_pull_from_ecr.sh.erb", "terraform_v2/lib/scripts/update_service_pull_from_ecr.sh"
		end
	end
end