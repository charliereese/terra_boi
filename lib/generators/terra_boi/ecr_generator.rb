require "generators/extensions"

module TerraBoi
	class EcrGenerator < Rails::Generators::Base
		attr_accessor :application_name
		source_root File.expand_path('templates', __dir__)

		desc (<<-EOF
			Generate AWS Elastic Container Registry (for storing container images)
			
			To execute, run rails generate terra_boi:ecr
			EOF
			.gsub(/\t/, '')
		)

		def init
			# defined in lib/generators/extensions
			self.application_name = generate_application_name
		end

		def create_ecr
			template "ecr/ecs_role.tf.erb", "terraform_v2/ecr/ecs_role.tf"
			template "ecr/main.tf.erb", "terraform_v2/ecr/main.tf"
			template "ecr/output.tf.erb", "terraform_v2/ecr/output.tf"
			template "ecr/var.tf.erb", "terraform_v2/ecr/var.tf"
		end
	end
end